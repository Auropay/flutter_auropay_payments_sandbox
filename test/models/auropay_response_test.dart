import 'package:auropay_payments_sandbox/models/auropay_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final successJson = {
    'transactionStatus': 2,
    'orderId': 'test09890',
    'transactionId': 'testId'
  };

  final successModel = SuccessData(
      transactionStatus: TransactionStatus.authorized,
      orderId: 'test09890',
      transactionId: 'testId');

  final successDetailJson = {
    'orderId': 'test09890',
    'transactionStatus': 3,
    'transactionId': 'testId',
    'transactionDate': '12/09/2023',
    'referenceNo': 'ref0',
    'processMethod': 1,
    'reasonMessage': 'no reason',
    'amount': 10.0,
    'convenienceFee': 0,
    'taxAmount': 0,
    'discountAmount': 0,
    'captureAmount': 0
  };

  final successDetailModel = SuccessDetail(
      orderId: 'test09890',
      transactionStatus: 3,
      transactionId: 'testId',
      transactionDate: '12/09/2023',
      referenceNo: 'ref0',
      processMethod: 1,
      reasonMessage: 'no reason',
      amount: 10.0,
      convenienceFee: 0.0,
      taxAmount: 0.0,
      discountAmount: 0.0,
      captureAmount: 0.0);

  final failedJson = {'error': 'Error message', 'errorCode': '201'};

  final failedModel = FailureData(message: 'Error message', errorCode: '201');

  test('auropay response success from json test', () {
    final json = {
      'type': 'success',
      'data': successJson,
    };

    expect(AuropayResponse.fromJson(json),
        AuropayResponse(type: ResponseType.success, data: successModel));
  });

  test('auropay response failed from json test', () {
    final json = {
      'type': 'failed',
      'data': failedJson,
    };

    expect(AuropayResponse.fromJson(json),
        AuropayResponse(type: ResponseType.failed, data: failedModel));
  });

  test('auropay response success detail from json test', () {
    final json = {
      'type': 'success',
      'data': successDetailJson,
    };

    expect(AuropayResponse.fromJson(json),
        AuropayResponse(type: ResponseType.success, data: successDetailModel));
  });

  test('transaction status value test', () {
    expect(TransactionStatus.created.value, 0);
    expect(TransactionStatus.posted.value, 1);
    expect(TransactionStatus.authorized.value, 2);
    expect(TransactionStatus.pending.value, 3);
    expect(TransactionStatus.cancelled.value, 4);
    expect(TransactionStatus.failed.value, 5);
    expect(TransactionStatus.declined.value, 6);
    expect(TransactionStatus.refundAttempted.value, 9);
    expect(TransactionStatus.refunded.value, 10);
    expect(TransactionStatus.voidAttempted.value, 11);
    expect(TransactionStatus.voided.value, 12);
    expect(TransactionStatus.success.value, 16);
    expect(TransactionStatus.denied.value, 17);
    expect(TransactionStatus.hold.value, 18);
    expect(TransactionStatus.refundFailed.value, 19);
    expect(TransactionStatus.partialRefundAttempted.value, 20);
    expect(TransactionStatus.partiallyRefunded.value, 21);
    expect(TransactionStatus.userCancelled.value, 22);
    expect(TransactionStatus.expired.value, 23);
    expect(TransactionStatus.settlementFailed.value, 24);
    expect(TransactionStatus.approved.value, 25);
  });
}
