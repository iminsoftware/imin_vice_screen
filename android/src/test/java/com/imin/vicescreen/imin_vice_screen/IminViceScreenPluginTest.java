package com.imin.vicescreen.imin_vice_screen;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verifyNoInteractions;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import org.junit.Test;

public class IminViceScreenPluginTest {

  /**
   * Methods without a native handler are relayed to the vice-screen channel, never answered
   * on the main channel; with no vice screen attached the call is dropped without crashing.
   */
  @Test
  public void onMethodCall_unknownMethod_isForwardedNotAnswered() {
    IminViceScreenPlugin plugin = new IminViceScreenPlugin();
    MethodChannel.Result mockResult = mock(MethodChannel.Result.class);

    plugin.onMethodCall(new MethodCall("methodWithoutNativeHandler", null), mockResult);

    verifyNoInteractions(mockResult);
  }
}
