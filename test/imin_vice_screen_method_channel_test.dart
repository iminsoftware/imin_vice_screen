import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imin_vice_screen/imin_vice_screen_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelIminViceScreen platform = MethodChannelIminViceScreen();
  const MethodChannel channel = MethodChannel('imin_vice_screen');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return true;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('isSupportMultipleScreen', () async {
    expect(await platform.isSupportMultipleScreen(), true);
  });
}
