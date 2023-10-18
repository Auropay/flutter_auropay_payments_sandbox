import 'package:auropay_payments_sandbox/models/auropay_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('auropay theme to json test', () {
    final theme = AuropayTheme(
        primaryColor: Colors.redAccent,
        colorOnPrimary: Colors.black,
        secondaryColor: Colors.white,
        colorOnSecondary: Colors.red);

    expect(theme.toJson(), {
      'primaryColor': 'ff5252',
      'colorOnPrimary': '000000',
      'secondaryColor': 'ffffff',
      'colorOnSecondary': 'f44336'
    });
  });
}
