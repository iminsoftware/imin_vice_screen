import 'dart:async';

import 'package:flutter/services.dart';
import 'package:imin_vice_screen/style.dart';

import 'enums.dart';
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

  Future<void> sendLCDCommand(LCDCommand command) {
    return IminViceScreenPlatform.instance.sendLCDCommand(command);
  }

  Future<void> sendLCDString(String string) {
    return IminViceScreenPlatform.instance.sendLCDString(string);
  }

  Future<void> sendLCDMultiString(
      {required List<String> contents, required List<int> aligns}) {
    return IminViceScreenPlatform.instance
        .sendLCDMultiString(contents: contents, aligns: aligns);
  }

  Future<void> sendLCDDoubleString(
      {required String topText, required String bottomText}) {
    return IminViceScreenPlatform.instance
        .sendLCDDoubleString(topText: topText, bottomText: bottomText);
  }

  Future<void> sendLCDBitmap(dynamic byte, {IminPictureStyle? pictureStyle}) {
    return IminViceScreenPlatform.instance.sendLCDBitmap(byte, pictureStyle: pictureStyle);
  }

  Future<void> setTextSize(int size) {
    return IminViceScreenPlatform.instance.sendLCDBitmap(size);
  }
}
