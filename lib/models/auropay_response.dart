/// [TransactionStatus]
/// success status code response from payment
enum TransactionStatus {
  created(0),
  posted(1),
  authorized(2),
  pending(3),
  cancelled(4),
  failed(5),
  declined(6),
  refundAttempted(9),
  refunded(10),
  voidAttempted(11),
  voided(12),
  success(16),
  denied(17),
  hold(18),
  refundFailed(19),
  partialRefundAttempted(20),
  partiallyRefunded(21),
  userCancelled(22),
  expired(23),
  settlementFailed(24),
  approved(25);

  const TransactionStatus(this.value);

  final int value;

  factory TransactionStatus.fromValue(int status) {
    return values.firstWhere((e) => e.value == status);
  }
}

enum ResponseType { success, failed }

/// [AuropayResponse]
/// General response class from native paltform
class AuropayResponse {
  final ResponseType type;
  final Data data;

  AuropayResponse({required this.type, required this.data});

  factory AuropayResponse.fromJson(Map<dynamic, dynamic> json) {
    return json['type'] == 'success'
        ? (json['data'] as Map<dynamic, dynamic>).containsKey('referenceNo')
            ? AuropayResponse(
                type: ResponseType.success, data: SuccessDetail.fromJson(json['data']))
            : AuropayResponse(
                type: ResponseType.success, data: SuccessData.fromJson(json['data']))
        : AuropayResponse(
            type: ResponseType.failed, data: FailureData.fromJson(json['data']));
  }

  @override
  String toString() => 'AuropayResponse { type: ${type.name}, ${data.toString()} }';

  @override
  bool operator ==(Object other) {
    return (other as AuropayResponse).type == type && other.data == data;
  }

  @override
  int get hashCode => type.hashCode + data.hashCode;
}

abstract class Data {}

/// receive success response from native platform
class SuccessData implements Data {
  final TransactionStatus transactionStatus;
  final String orderId;
  final String transactionId;

  SuccessData({
    required this.transactionStatus,
    required this.orderId,
    required this.transactionId,
  });

  factory SuccessData.fromJson(Map<dynamic, dynamic> json) {
    return SuccessData(
      transactionStatus: TransactionStatus.fromValue(json['transactionStatus']),
      orderId: json['orderId'],
      transactionId: json['transactionId'],
    );
  }

  @override
  String toString() =>
      'data { transactionStatus: $transactionStatus, orderId: $orderId, transactionId: $transactionId }';

  @override
  bool operator ==(Object other) {
    return (other as SuccessData).transactionStatus == transactionStatus &&
        other.transactionId == transactionId &&
        other.orderId == orderId;
  }

  @override
  int get hashCode =>
      transactionStatus.hashCode + transactionId.hashCode + orderId.hashCode;
}

/// Receive failure from Native platform
///
class FailureData implements Data {
  final String message;
  final String? errorCode;

  FailureData({required this.message, this.errorCode});

  factory FailureData.fromJson(Map<dynamic, dynamic> json) {
    print("Failed data :: ${json.toString()}");
    return FailureData(message: json['error'], errorCode: json['errorCode']);
  }

  @override
  String toString() => 'data { message: $message, errorCode: $errorCode }';

  @override
  bool operator ==(Object other) {
    return (other as FailureData).message == message && other.errorCode != null
        ? other.errorCode == errorCode
        : true;
  }

  @override
  int get hashCode => message.hashCode + errorCode.hashCode;
}

/// success response with detail
class SuccessDetail implements Data {
  final String orderId;
  final int transactionStatus;
  final String transactionId;
  final String transactionDate;
  final String referenceNo;
  final int processMethod;
  final String reasonMessage;
  final double amount;
  final double convenienceFee;
  final double taxAmount;
  final double discountAmount;
  final double captureAmount;

  SuccessDetail({
    required this.orderId,
    required this.transactionStatus,
    required this.transactionId,
    required this.transactionDate,
    required this.referenceNo,
    required this.processMethod,
    required this.reasonMessage,
    required this.amount,
    required this.convenienceFee,
    required this.taxAmount,
    required this.discountAmount,
    required this.captureAmount,
  });

  factory SuccessDetail.fromJson(Map<dynamic, dynamic> json) {
    return SuccessDetail(
        orderId: json['orderId'],
        transactionStatus: json['transactionStatus'],
        transactionId: json['transactionId'],
        transactionDate: json['transactionDate'],
        referenceNo: json['referenceNo'],
        processMethod: json['processMethod'],
        reasonMessage: json['reasonMessage'],
        amount: json['amount'],
        convenienceFee: json['convenienceFee'].toDouble(),
        taxAmount: json['taxAmount'].toDouble(),
        discountAmount: json['discountAmount'].toDouble(),
        captureAmount: json['captureAmount'].toDouble());
  }

  @override
  bool operator ==(Object other) {
    return (other as SuccessDetail).orderId == orderId &&
        other.transactionStatus == transactionStatus &&
        other.transactionId == transactionId &&
        other.transactionDate == transactionDate &&
        other.referenceNo == referenceNo &&
        other.processMethod == processMethod &&
        other.reasonMessage == reasonMessage &&
        other.amount == amount &&
        other.convenienceFee == convenienceFee &&
        other.taxAmount == taxAmount &&
        other.discountAmount == discountAmount &&
        other.captureAmount == captureAmount;
  }

  @override
  int get hashCode => orderId.hashCode + transactionId.hashCode;
}
