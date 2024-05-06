package com.imin.vicescreen.imin_vice_screen;

import android.app.Presentation;
import android.content.Context;
import android.os.Bundle;
import android.view.Display;

import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.FlutterEngine;

class IminViceScreenPresentation extends Presentation {
    private Context outerContext;
    private Display display;
    private FlutterEngine engine;

    public IminViceScreenPresentation(Context outerContext, Display display, FlutterEngine engine) {
        super(outerContext, display);
        this.outerContext = outerContext;
        this.display = display;
        this.engine = engine;

    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.flutter_presentation_view);
        FlutterView flutterView = findViewById(R.id.flutter_presentation_view);
        flutterView.attachToFlutterEngine(engine);
    }

    @Override
    public void show() {
        super.show();
        engine.getLifecycleChannel().appIsResumed();
    }

    @Override
    public void dismiss() {
        engine.getLifecycleChannel().appIsDetached();
        super.dismiss();
    }
}