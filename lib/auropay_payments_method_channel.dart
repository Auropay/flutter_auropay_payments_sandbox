import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'auropay_payments_platform_interface.dart';
import 'models/auropay_builder.dart';

/// An implementation of [AuropayPaymentsPlatform] that uses method channels.
class MethodChannelAuropayPayments extends AuropayPaymentsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('net.auropay.auropay_payments');

  @override
  Future<Map<dynamic, dynamic>?> doPayment(
      {required AuropayBuilder builder,
      required double amount,
      String? referenceNumber}) async {
    final version = await methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'do_payment', builder.toJson(amount, referenceNumber: referenceNumber));
    return version;
  }
}
