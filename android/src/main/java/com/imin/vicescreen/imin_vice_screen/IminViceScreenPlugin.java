package com.imin.vicescreen.imin_vice_screen;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.provider.Settings;

import java.util.ArrayList;

import io.flutter.Log;
import io.flutter.embedding.engine.dart.DartExecutor;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * IminViceScreenPlugin
 */
public class IminViceScreenPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context _context;
    private MethodChannel viceScreenChannel;
    //用于设置副屏 flutterEngine 需要引入的三方插件库
    public ArrayList<FlutterPlugin> tripPlugins;
    //主屏路由
    String mainRouter = "main";
    //副屏路由
    String viceMainRouter = "viceMain";

    private void onCreateViceChannel(DartExecutor dartExecutor) {
        viceScreenChannel = new MethodChannel(dartExecutor, "imin_vice_screen_child");
        //将副屏事件中转给主屏的engine
        viceScreenChannel.setMethodCallHandler((call, result) -> {
            channel.invokeMethod(call.method, call.arguments);
        });
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "imin_vice_screen");
        _context = flutterPluginBinding.getApplicationContext();
        channel.setMethodCallHandler(this);
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            //是否支持多屏
            case "isSupportDoubleScreen":
                boolean isSupport = IminViceScreenProvider.getInstance().supportViceScreen();
                result.success(isSupport);
                break;
            //校验overlay权限
            case "checkOverlayPermission":
                boolean isGranted = IminViceScreenProvider.getInstance().checkOverlayPermission();
                result.success(isGranted);
                break;
            //请求overlay权限
            case "requestOverlayPermission":
                //申请 overlay 权限
                if (Build.VERSION.SDK_INT >= 23) {
                    Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION);
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                    _context.startActivity(intent);
                }
                result.success(true);
                break;
            //显示副屏
            case "doubleScreenShow":
                IminViceScreenProvider.getInstance().showSubDisplay();
                result.success(true);
                break;
            case "doubleScreenCancel":
                IminViceScreenProvider.getInstance().closeSubDisplay();
                result.success(true);
                break;
            default:
                //主屏通过mainChannel将事件和参数传递给副屏viceScreenChannel
                Log.d("TAG", "onMethodCall: " + viceScreenChannel);
                if (viceScreenChannel != null) {
                    viceScreenChannel.invokeMethod(call.method, call.arguments);
                }
                break;
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        viceScreenChannel.setMethodCallHandler(null);
    }

    @RequiresApi(Build.VERSION_CODES.JELLY_BEAN_MR1)
    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        IminViceScreenProvider.getInstance().setFlutterSubCallback(
                new IFlutterSubCallback() {
                    @Override
                    public void onSubFlutterEngineCreated() {
                        //副屏 engine 初始化后，将副屏事件进行分发
                        if (IminViceScreenProvider.getInstance().engine != null) {
                            onCreateViceChannel(IminViceScreenProvider.getInstance().engine.getDartExecutor());
                        }
                    }
                }
        );
        boolean autoShowSubScreenWhenInit = _context.getResources().getBoolean(R.bool.autoShowSubScreenWhenInit);
        IminViceScreenProvider.getInstance().doInit(binding.getActivity(), autoShowSubScreenWhenInit);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivity() {
        IminViceScreenProvider.getInstance().onDispose();
    }

   public static IminViceScreenPlugin getInstance() {
        return Holder.instance;
    }

    private static class Holder {
        private static final IminViceScreenPlugin instance = new IminViceScreenPlugin();
    }

}
