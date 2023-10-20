import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'auropay_payments_method_channel.dart';
import 'models/auropay_builder.dart';

abstract class AuropayPaymentsPlatform extends PlatformInterface {
  /// Constructs a AuropayPaymentsSandboxPlatform.
  AuropayPaymentsPlatform() : super(token: _token);

  static final Object _token = Object();

  static AuropayPaymentsPlatform _instance = MethodChannelAuropayPayments();

  /// The default instance of [AuropayPaymentsPlatform] to use.
  ///
  /// Defaults to [MethodChannelAuropayPayments].
  static AuropayPaymentsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AuropayPaymentsPlatform] when
  /// they register themselves.
  static set instance(AuropayPaymentsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// [doPayment]
  /// @param [AuropayBuilder]
  ///
  /// initiate payment with platform specific chanel and required data
  Future<Map<dynamic, dynamic>?> doPayment(
      {required AuropayBuilder builder,
      required double amount,
      String? referenceNumber}) {
    throw UnimplementedError('Auropay has been not initialized.');
  }
}
