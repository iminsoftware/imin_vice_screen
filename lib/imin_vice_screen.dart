import 'dart:async';

import 'package:flutter/services.dart';

import 'imin_vice_screen_platform_interface.dart';

class IminViceScreen {
  StreamController<MethodCall>? viceStreamController;
  StreamController<MethodCall>? mainStreamController;
  Stream<MethodCall> get mainStream {
    // 创建一个StreamController，用于发送消息给子屏幕
    mainStreamController ??= StreamController<MethodCall>.broadcast();
    IminViceScreenPlatform.instance.initMainChannel(mainStreamController);
    return mainStreamController!.stream;
  }

  Stream<MethodCall> get viceStream {
    // 创建一个StreamController，用于接收子屏幕发送的消息
    viceStreamController ??= StreamController<MethodCall>.broadcast();
    IminViceScreenPlatform.instance.initViceChannel(viceStreamController);
    return viceStreamController!.stream;
  }

  Future<bool?> isSupportMultipleScreen() {
    return IminViceScreenPlatform.instance.isSupportMultipleScreen();
  }

  Future<bool?> checkOverlayPermission() {
    return IminViceScreenPlatform.instance.checkOverlayPermission();
  }

  Future<void> requestOverlayPermission() {
    return IminViceScreenPlatform.instance.requestOverlayPermission();
  }

  Future<void> doubleScreenOpen() {
    return IminViceScreenPlatform.instance.doubleScreenOpen();
  }

  Future<void> doubleScreenCancel() {
    return IminViceScreenPlatform.instance.doubleScreenCancel();
  }

  Future<void> sendMsgToViceScreen(String method,
      {Map<String, dynamic>? params}) {
    return IminViceScreenPlatform.instance
        .sendMsgToViceScreen(method, params: params);
  }

  Future<void> sendMsgToMainScreen(String method,
      {Map<String, dynamic>? params}) {
    return IminViceScreenPlatform.instance
        .sendMsgToMainScreen(method, params: params);
  }
}
