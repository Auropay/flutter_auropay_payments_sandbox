import 'package:auropay_payments_sandbox/models/auropay_builder.dart';
import 'package:auropay_payments_sandbox/models/auropay_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auropay_payments_sandbox/auropay_payments.dart';
import 'package:auropay_payments_sandbox/auropay_payments_platform_interface.dart';
import 'package:auropay_payments_sandbox/auropay_payments_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAuropayPaymentsPlatform
    with MockPlatformInterfaceMixin
    implements AuropayPaymentsPlatform {
  @override
  Future<Map?> doPayment(
          {required AuropayBuilder builder,
          required double amount,
          String? referenceNumber,
          String? orderId}) =>
      Future.value({
        'type': 'success',
        'data': {
          'transactionStatus': 2,
          'orderId': 'j8u7ygt65r',
          'transactionId': '2w3es4rd6tf7yu8i'
        }
      });
}

void main() {
  final AuropayPaymentsPlatform initialPlatform =
      AuropayPaymentsPlatform.instance;

  test('$MethodChannelAuropayPayments is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAuropayPayments>());
  });

  test('doPayment', () async {
    AuropayPayments auropayPaymentsSandboxPlugin = AuropayPayments();
    MockAuropayPaymentsPlatform fakePlatform = MockAuropayPaymentsPlatform();
    AuropayPaymentsPlatform.instance = fakePlatform;

    expect(
        await auropayPaymentsSandboxPlugin.doPayment(
          builder: AuropayBuilder(
              subDomainId: 'testXYZ',
              accessKey: 'test123',
              secretKey: 'testABC',
              customerProfile: CustomerProfile(
                  title: 'Customer Title',
                  email: 'mail@yopmail.com',
                  lastName: 'Lastname',
                  firstName: 'Firstname',
                  middleName: 'MiddleName',
                  phone: '9087654321')),
          amount: 2.00,
        ),
        AuropayResponse(
            type: ResponseType.success,
            data: SuccessData(
                transactionStatus: TransactionStatus.authorized,
                orderId: 'j8u7ygt65r',
                transactionId: '2w3es4rd6tf7yu8i')));
  });
}
