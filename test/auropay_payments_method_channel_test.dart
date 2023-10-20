import 'package:auropay_payments_sandbox/models/auropay_builder.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auropay_payments_sandbox/auropay_payments_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAuropayPayments platform = MethodChannelAuropayPayments();
  const MethodChannel channel = MethodChannel('net.auropay.auropay_payments');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return {'status': 'success', 'data': 'token:98iu7y6t5rf3g5h7d8te'};
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('doPayment', () async {
    expect(
        await platform.doPayment(
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
        {'status': 'success', 'data': 'token:98iu7y6t5rf3g5h7d8te'});
  });
}
