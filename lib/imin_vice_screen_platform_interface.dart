import 'dart:async';

import 'package:flutter/services.dart';
import 'package:imin_vice_screen/style.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'enums.dart';
import 'imin_vice_screen_method_channel.dart';

abstract class IminViceScreenPlatform extends PlatformInterface {
  /// Constructs a IminViceScreenPlatform.
  IminViceScreenPlatform() : super(token: _token);

  static final Object _token = Object();

  static IminViceScreenPlatform _instance = MethodChannelIminViceScreen();

  /// The default instance of [IminViceScreenPlatform] to use.
  ///
  /// Defaults to [MethodChannelIminViceScreen].
  static IminViceScreenPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IminViceScreenPlatform] when
  /// they register themselves.
  static set instance(IminViceScreenPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> isSupportMultipleScreen() {
    throw UnimplementedError(
        'isSupportMultipleScreen() has not been implemented.');
  }

  Future<bool?> checkOverlayPermission() {
    throw UnimplementedError(
        'checkOverlayPermission() has not been implemented.');
  }

  Future<void> doubleScreenCancel() {
    throw UnimplementedError('doubleScreenCancel() has not been implemented.');
  }

  Future<void> requestOverlayPermission() {
    throw UnimplementedError(
        'requestOverlayPermission() has not been implemented.');
  }

  Future<void> doubleScreenOpen() {
    throw UnimplementedError('doubleScreenOpen() has not been implemented.');
  }

  Future<void> sendMsgToViceScreen(String method,
      {Map<String, dynamic>? params}) {
    throw UnimplementedError('sendMsgToViceScreen() has not been implemented.');
  }

  Future<void> sendMsgToMainScreen(String method,
      {Map<String, dynamic>? params}) {
    throw UnimplementedError('sendMsgToMainScreen() has not been implemented.');
  }

  void initViceChannel(StreamController<MethodCall>? viceStreamController) {
    throw UnimplementedError('initViceChannel() has not been implemented.');
  }

  void initMainChannel(StreamController<MethodCall>? mainStreamController) {
    throw UnimplementedError('initMainChannel() has not been implemented.');
  }

  Future<void> sendLCDCommand(LCDCommand command) {
    throw UnimplementedError('sendLCDCommand() has not been implemented.');
  }

  Future<void> sendLCDString(String string) {
    throw UnimplementedError('sendLCDString() has not been implemented.');
  }

  Future<void> sendLCDMultiString(
      {required List<String> contents, required List<int> aligns}) {
    throw UnimplementedError('sendLCDMultiString() has not been implemented.');
  }

  Future<void> sendLCDDoubleString(
      {required String topText, required String bottomText}) {
    throw UnimplementedError('sendLCDDoubleString() has not been implemented.');
  }
  Future<void> sendLCDBitmap(dynamic byte, {IminPictureStyle? pictureStyle}) {
    throw UnimplementedError('sendLCDBitmap() has not been implemented.');
  }
  Future<void> setTextSize(int size) {
    throw UnimplementedError('setTextSize() has not been implemented.');
  }
}
