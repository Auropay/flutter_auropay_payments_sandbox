package net.auropay.auropay_payments_sandbox

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.test.Test
import org.mockito.Mockito

/*
 * This demonstrates a simple unit test of the Kotlin portion of this plugin's implementation.
 *
 * Once you have built the plugin's example app, you can run these tests from the command
 * line by running `./gradlew testDebugUnitTest` in the `example/android/` directory, or
 * you can run them directly from IDEs that support JUnit such as Android Studio.
 */

internal class AuropayPaymentsSandboxPluginTest {
  @Test
  fun onMethodCall_getPlatformVersion_returnsExpectedValue() {
    val plugin = AuropayPaymentsSandboxPlugin()

    val customer = mapOf<String, Any>(
      "title" to "testAuropay",
      "firstName" to "Vishal",
      "middleName" to "",
      "lastName" to "Golakiya",
      "phone" to "9081234567",
      "email" to "vishal@yopmail.com",
      "amount" to 10.0
    )

    val arguments = mapOf<String, Any>(
      "subDomainId" to "domain",
      "accessKey" to "key890",
      "secretKey" to "key890",
      "customerProfile" to customer,
    )

    val call = MethodCall("do_payment", arguments)
    val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
    plugin.onMethodCall(call, mockResult)

//    Mockito.verify(mockResult).success("Android " + android.os.Build.VERSION.RELEASE)
  }
}
