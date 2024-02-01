package com.imin.vicescreen.imin_vice_screen;

import android.app.Activity;

import android.content.Context;
import android.media.MediaRouter;
import android.view.Display;
import android.os.Build;

import androidx.annotation.RequiresApi;

import io.flutter.Log;
import io.flutter.embedding.engine.FlutterEngine;

import android.provider.Settings;
import android.view.WindowManager;

import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.dart.DartExecutor;


public class IminViceScreenProvider {
    FlutterEngine engine;
    private Activity currentActivity;
    private IminViceScreenPresentation presentation;
    private IFlutterSubCallback iCallback;
    private MediaRouter mediaRouter;

    public static IminViceScreenProvider getInstance() {
        return Holder.instance;
    }

    private static class Holder {
        private static final IminViceScreenProvider instance = new IminViceScreenProvider();
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public void doInit(Activity activity, boolean showSubScreen) {
        currentActivity = activity;
        mediaRouter = (MediaRouter) activity.getApplicationContext().getSystemService(Context.MEDIA_ROUTER_SERVICE);

        //媒体设备监听
        if (mediaRouter != null) {
            mediaRouter.addCallback(MediaRouter.ROUTE_TYPE_LIVE_VIDEO, mMediaRouterCallback);
        }
        if (showSubScreen) {
            showSubDisplay();
        }
    }

    private MediaRouter.SimpleCallback mMediaRouterCallback = new MediaRouter.SimpleCallback() {
        @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public void onRouteSelected(MediaRouter router, int type, MediaRouter.RouteInfo info) {
            showSubDisplay();
        }

        @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public void onRouteUnselected(MediaRouter router, int type, MediaRouter.RouteInfo info) {
            closeSubDisplay();
        }

        @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
        @Override
        public void onRoutePresentationDisplayChanged(MediaRouter router, MediaRouter.RouteInfo info) {
            showSubDisplay();

        }
    };

    public void setFlutterSubCallback(IFlutterSubCallback callback) {
        iCallback = callback;
    }


    public void onDispose() {
        try {
            if (mediaRouter != null) {
                mediaRouter.removeCallback(mMediaRouterCallback);
            }
        } catch (Exception e) {

        }

    }

    /**
     * 初始化副屏 flutterEngine
     */
    private void doInitEngine() {
        if (currentActivity != null) {
            if (engine != null) {
                return;
            }
            //初始化副屏
            engine = new FlutterEngine(currentActivity);
            //设置副屏engine需要引入的三方插件库
            Log.d("TAG", "tripPlugins: " + IminViceScreenPlugin.getInstance().getTripPlugins());
            if (IminViceScreenPlugin.getInstance().getTripPlugins() != null) {
                 IminViceScreenPlugin.getInstance().getTripPlugins().forEach(plugin -> {
                      if(engine.getPlugins() != null) {
                          engine.getPlugins().add(plugin);
                      }
                 });
            }
            if (engine != null) {
                if (engine.getNavigationChannel() != null) {
                    engine.getNavigationChannel().setInitialRoute(IminViceScreenPlugin.getInstance().viceMainRouter);
                }
                if (engine.getDartExecutor() != null) {
                    engine.getDartExecutor().executeDartEntrypoint(
                            new DartExecutor.DartEntrypoint(
                                    FlutterInjector.instance().flutterLoader().findAppBundlePath(),
                                    IminViceScreenPlugin.getInstance().getInstance().mainRouter
                            )
                    );
                }
            }
            if (iCallback != null) {
                iCallback.onSubFlutterEngineCreated();
            }
        }
    }

    /**
     * 获取扩展显示屏
     */
    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public Display getPresentationDisplay() {
        if (mediaRouter != null) {
            MediaRouter.RouteInfo route = mediaRouter.getSelectedRoute(MediaRouter.ROUTE_TYPE_LIVE_VIDEO);
            if (route != null) {
                return route.getPresentationDisplay();
            }
        }
        return null;
    }

    /**
     * 是否支持双屏
     */
    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public boolean supportViceScreen() {
        return getPresentationDisplay() != null;
    }

    /**
     * show副屏
     */
    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public void showSubDisplay() {
        closeSubDisplay();
        if (currentActivity != null && !currentActivity.isFinishing()) {
            configSecondDisplay(currentActivity.getApplicationContext());
        }
    }

    /**
     * hide副屏
     */
    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public void closeSubDisplay() {
        if (presentation != null && presentation.isShowing()) {
            presentation.dismiss();
        }
        presentation = null;
    }

    /**
     * 校验是否具备 overlay 权限
     */
    public boolean checkOverlayPermission() {
        if (Build.VERSION.SDK_INT >= 23 && currentActivity != null) {
            return Settings.canDrawOverlays(currentActivity);
        } else {
            return true;
        }
    }

    /**
     * 显示扩展屏内容
     */
    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    public void configSecondDisplay(Context context) {
        Display display = getPresentationDisplay();
        Log.d("TAG", "configSecondDisplay" + display);
        if (display != null) {
            doInitEngine();
            if (engine != null) {
                try {
                    presentation = new IminViceScreenPresentation(context, display, engine);

                    if (presentation != null) {
                        if (checkOverlayPermission()) {
                            if (presentation.getWindow() != null) {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                                    // presentation.getWindow().setType(WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY);
                                    presentation.getWindow().setType(2037);
                                } else {
                                    Log.d("TAG", "configSecondDisplay" + "TYPE_SYSTEM_ALERT");
                                    // presentation.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
                                }
                            }

                        }
                        presentation.show();
                    }
                } catch (Throwable e) {
                    e.printStackTrace();
                }
            }
        }
    }

}