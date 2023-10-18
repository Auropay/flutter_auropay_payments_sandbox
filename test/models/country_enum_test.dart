import 'package:auropay_payments_sandbox/models/country_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('country enum value test', () {
    expect(Country.IN.value, 'in');
    expect(Country.US.value, 'us');
  });
}