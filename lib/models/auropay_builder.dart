import 'auropay_theme.dart';
import 'country_enum.dart';

/// [AuropayBuilder]
/// A builder for auropay entity.
class AuropayBuilder {
  /// required to setup payment channel
  final String subDomainId;

  /// required to setup payment channel
  final String accessKey;

  /// required to setup payment channel
  final String secretKey;

  /// required to setup payment channel
  final CustomerProfile customerProfile;

  /// default true
  ///
  /// true: apply auto contrast color when applying custom theme
  /// false: apply default color combination
  bool autoContrast = true;

  /// default true
  ///
  /// true: will after successfully completion of payment will show the receipt
  /// false: without showing receipt will close the payment module
  bool showReceipt = true;

  /// default [Country.IN]
  ///
  /// set supported country from [Country]
  Country country = Country.IN;

  /// apply custom color combination for payment module
  AuropayTheme? theme;

  /// option for card scan
  ///
  /// for iOS user
  bool allowCardScan = false;

  /// default false
  ///
  /// true: will return detailed response on success payment.
  bool detailedResponse = false;


  /// ask for customer detail
  ///
  /// true: will show a form for customer detail
  bool showCustomerForm = false;

  AuropayBuilder({
    required this.subDomainId,
    required this.accessKey,
    required this.secretKey,
    required this.customerProfile,
  });

  AuropayBuilder setAutoContrast(bool autoContrast) {
    this.autoContrast = autoContrast;
    return this;
  }

  AuropayBuilder setShowReceipt(bool showReceipt) {
    this.showReceipt = showReceipt;
    return this;
  }

  AuropayBuilder setCountry(Country country) {
    this.country = country;
    return this;
  }

  AuropayBuilder setTheme(AuropayTheme theme) {
    this.theme = theme;
    return this;
  }

  AuropayBuilder setAllowCardScan(bool allowCardScan) {
    this.allowCardScan = allowCardScan;
    return this;
  }

  AuropayBuilder getDetailedResponse(bool detailedResponse) {
    this.detailedResponse = detailedResponse;
    return this;
  }


  AuropayBuilder askForCustomerDetail(bool showCustomerForm) {
    this.showCustomerForm = showCustomerForm;
    return this;
  }

  AuropayBuilder build() {
    return this;
  }

  Map<String, dynamic> toJson(double amount, {String? referenceNumber}) {
    final map = <String, dynamic>{};
    map['subDomainId'] = subDomainId;
    map['accessKey'] = accessKey;
    map['secretKey'] = secretKey;
    map['amount'] = amount;
    map['customerProfile'] = customerProfile.toJson();
    map["autoContrast"] = autoContrast;
    map["showReceipt"] = showReceipt;
    map['country'] = country.value;
    map['allowCardScan'] = allowCardScan;
    if (theme != null) {
      map['theme'] = theme?.toJson();
    }
    map['detailedResponse'] = detailedResponse;
    if (referenceNumber != null) {
      map['referenceNumber'] = referenceNumber;
    }
    map['showCustomerForm'] = showCustomerForm;
    return map;
  }
}

class CustomerProfile {
  final String title;
  final String firstName;
  final String middleName;
  final String lastName;
  final String phone;
  final String email;

  CustomerProfile({
    required this.title,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['firstName'] = firstName;
    map['middleName'] = middleName;
    map['lastName'] = lastName;
    map['phone'] = phone;
    map['email'] = email;
    return map;
  }
}
