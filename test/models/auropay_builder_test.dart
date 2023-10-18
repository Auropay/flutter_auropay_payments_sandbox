import 'package:auropay_payments_sandbox/models/auropay_builder.dart';
import 'package:auropay_payments_sandbox/models/country_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('auropay builder toJson default data test', () {
    AuropayBuilder builder = AuropayBuilder(
        subDomainId: 'test',
        accessKey: 'key890',
        secretKey: 'key890',
        customerProfile: CustomerProfile(
            title: 'aurionpro',
            firstName: 'Vishal',
            middleName: '',
            lastName: 'Golakiya',
            phone: '9081234567',
            email: 'vishal@yopmail.com'));


    expect(builder.toJson(10),
        {
          "subDomainId": "test",
          "accessKey": "key890",
          "secretKey": "key890",
          "amount": 10,
          "customerProfile": {
            "title": "aurionpro",
            "firstName": "Vishal",
            "middleName": "",
            "lastName": "Golakiya",
            "phone": "9081234567",
            "email": "vishal@yopmail.com"
          },
          "autoContrast": true,
          "showReceipt": true,
          "country": "in",
          "allowCardScan": false,
          "detailedResponse": false,
          "showCustomerForm": false
        });
  });

  test('auropay builder toJson test', () {
    AuropayBuilder builder = AuropayBuilder(
        subDomainId: 'test',
        accessKey: 'key890',
        secretKey: 'key890',
        customerProfile: CustomerProfile(
            title: 'aurionpro',
            firstName: 'Vishal',
            middleName: '',
            lastName: 'Golakiya',
            phone: '9081234567',
            email: 'vishal@yopmail.com'));

    builder.setShowReceipt(false);
    builder.setAutoContrast(false);
    builder.setCountry(Country.US);
    builder.askForCustomerDetail(true);
    builder.getDetailedResponse(true);
    builder.setAllowCardScan(true);

    expect(builder.toJson(10),
        {
          "subDomainId": "test",
          "accessKey": "key890",
          "secretKey": "key890",
          "amount": 10,
          "customerProfile": {
            "title": "aurionpro",
            "firstName": "Vishal",
            "middleName": "",
            "lastName": "Golakiya",
            "phone": "9081234567",
            "email": "vishal@yopmail.com"
          },
          "autoContrast": false,
          "showReceipt": false,
          "country": "us",
          "allowCardScan": true,
          "detailedResponse": true,
          "showCustomerForm": true
        });
  });
}
