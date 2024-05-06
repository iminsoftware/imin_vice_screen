import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:imin_vice_screen/style.dart';

import 'enums.dart';
import 'imin_vice_screen_platform_interface.dart';
import 'package:logger/logger.dart';

var logger = Logger();

/// An implementation of [IminViceScreenPlatform] that uses method channels.
class MethodChannelIminViceScreen extends IminViceScreenPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('imin_vice_screen');
  @visibleForTesting
  final viceMethodChannel = const MethodChannel('imin_vice_screen_child');

  @override
  void initViceChannel(StreamController<MethodCall>? viceStreamController) {
    viceMethodChannel.setMethodCallHandler((MethodCall call) async {
      //副屏channel 每接收到一个事件都放进去流里, 由外部监听
      viceStreamController?.sink.add(call);
    });
  }

  @override
  void initMainChannel(StreamController<MethodCall>? mainStreamController) {
    methodChannel.setMethodCallHandler((MethodCall call) async {
      //主屏channel 每接收到一个事件都放进去流里, 由外部监听
      mainStreamController?.sink.add(call);
    });
  }

  ///返回是否支持双屏
  @override
  Future<bool?> isSupportMultipleScreen() async {
    return await methodChannel.invokeMethod<bool>('isSupportDoubleScreen');
  }

  ///校验overlay窗口权限
  @override
  Future<bool?> checkOverlayPermission() async {
    return await methodChannel.invokeMethod<bool>('checkOverlayPermission');
  }

  /// 请求overlay窗口权限
  @override
  Future<void> requestOverlayPermission() async {
    await methodChannel.invokeMethod<void>('requestOverlayPermission');
  }

  ///打开副屏
  @override
  Future<void> doubleScreenOpen() async {
    await methodChannel.invokeMethod<void>('doubleScreenOpen');
  }

  ///关闭副屏
  @override
  Future<void> doubleScreenCancel() async {
    await methodChannel.invokeMethod<void>('doubleScreenCancel');
  }

  ///发送消息到副屏
  @override
  Future<void> sendMsgToViceScreen(String method,
      {Map<String, dynamic>? params}) async {
    await methodChannel.invokeMethod<void>(method, params ?? {});
  }

  ///发送消息到主屏
  @override
  Future<void> sendMsgToMainScreen(String method,
      {Map<String, dynamic>? params}) async {
    await viceMethodChannel.invokeMethod<void>(method, params ?? {});
  }

  @override
  Future<void> sendLCDCommand(LCDCommand command) async {
    Map<String, dynamic> arguments = <String, dynamic>{
      "command": command.state,
    };
    await methodChannel.invokeMethod<void>('sendLCDCommand', arguments);
  }

  @override
  Future<void> sendLCDString(String string) async {
    Map<String, dynamic> arguments = <String, dynamic>{
      "content": string,
    };
    await methodChannel.invokeMethod<void>('sendLCDString', arguments);
  }

  @override
  Future<void> sendLCDMultiString(
      {required List<String> contents, required List<int> aligns}) async {
    Map<String, dynamic> arguments = <String, dynamic>{
      "contents": json.encode(contents),
      "aligns": json.encode(aligns),
    };
    logger.d("sendLCDMultiString: $arguments");
    await methodChannel.invokeMethod<void>('sendLCDMultiString', arguments);
  }

  @override
  Future<void> sendLCDDoubleString(
      {required String topText, required String bottomText}) async {
    Map<String, dynamic> arguments = <String, dynamic>{
      "topText": topText,
      "bottomText": bottomText
    };
    await methodChannel.invokeMethod<void>('sendLCDDoubleString', arguments);
  }

  @override
  Future<void> sendLCDBitmap(dynamic byte,
      {IminPictureStyle? pictureStyle}) async {
    Map<String, dynamic> arguments = <String, dynamic>{};
    if (pictureStyle != null) {
      if (pictureStyle.width != null && pictureStyle.height != null) {
        arguments.putIfAbsent("width", () => pictureStyle.width);
        arguments.putIfAbsent("height", () => pictureStyle.height);
      }
    }
    arguments.putIfAbsent("bitmap", () => byte);
    if (byte is Uint8List) {
      await methodChannel.invokeMethod<void>('sendLCDBitmap', arguments);
    } else {
      await methodChannel.invokeMethod<void>('sendLCDBitmapToUrl', arguments);
    }
  }

  @override
  Future<void> setTextSize(int size) async {
    Map<String, dynamic> arguments = <String, dynamic>{
      "size": size,
    };
     await methodChannel.invokeMethod<void>('setTextSize', arguments);
  }
}
