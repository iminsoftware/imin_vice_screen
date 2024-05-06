import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imin_vice_screen/enums.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';
import 'package:imin_vice_screen/imin_vice_screen_platform_interface.dart';
import 'package:imin_vice_screen/imin_vice_screen_method_channel.dart';
import 'package:imin_vice_screen/style.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockIminViceScreenPlatform
    with MockPlatformInterfaceMixin
    implements IminViceScreenPlatform {
  @override
  Future<void> initViceChannel(
          StreamController<MethodCall>? viceStreamController) =>
      Future.value();
  @override
  Future<void> initMainChannel(
          StreamController<MethodCall>? mainStreamController) =>
      Future.value();
  @override
  Future<bool?> isSupportMultipleScreen() => Future.value();
  @override
  Future<bool?> checkOverlayPermission() => Future.value();
  @override
  Future<void> requestOverlayPermission() => Future.value();
  @override
  Future<bool?> doubleScreenOpen() => Future.value();
  @override
  Future<bool?> doubleScreenCancel() => Future.value();
  @override
  Future<void> sendMsgToViceScreen(String method,
          {Map<String, dynamic>? params}) =>
      Future.value();
  @override
  Future<void> sendMsgToMainScreen(String method,
          {Map<String, dynamic>? params}) =>
      Future.value();
  @override
  Future<void> sendLCDCommand(LCDCommand command) => Future.value();
  @override
  Future<void> sendLCDString(String string) => Future.value();
  @override
  Future<void> sendLCDMultiString(
          {required List<String> contents, required List<int> aligns}) =>
      Future.value();
  @override
  Future<void> sendLCDDoubleString(
          {required String topText, required String bottomText}) =>
      Future.value();
  @override
  Future<void> sendLCDBitmap(dynamic byte, {IminPictureStyle? pictureStyle }) => Future.value();
  @override
  Future<void> setTextSize(int size) => Future.value();
}

void main() {
  final IminViceScreenPlatform initialPlatform =
      IminViceScreenPlatform.instance;

  test('$MethodChannelIminViceScreen is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelIminViceScreen>());
  });

  test('isSupportMultipleScreen', () async {
    IminViceScreen iminViceScreenPlugin = IminViceScreen();
    MockIminViceScreenPlatform fakePlatform = MockIminViceScreenPlatform();
    IminViceScreenPlatform.instance = fakePlatform;

    expect(await iminViceScreenPlugin.isSupportMultipleScreen(), true);
  });
}
