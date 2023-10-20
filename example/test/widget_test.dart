import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'app_setup.dart';

void main() {
  final amount = find.byKey(const ValueKey('tff_mount'));
  final firstname = find.byKey(const ValueKey('tff_firstname'));
  final lastname = find.byKey(const ValueKey('tff_lastname'));
  final email = find.byKey(const ValueKey('tff_email'));
  final phone = find.byKey(const ValueKey('tff_phone'));
  final payButton = find.byKey(const ValueKey('button_pay'));

  testWidgets('Simple app visibility test', (WidgetTester tester) async {
    await tester.pumpWidget(setupApp());

    expect(amount, findsOneWidget);
    expect(firstname, findsOneWidget);
    expect(lastname, findsOneWidget);
    expect(email, findsOneWidget);
    expect(phone, findsOneWidget);
  });

  testWidgets('Error message visibility test', (WidgetTester tester) async {
    await tester.pumpWidget(setupApp());
    await tester.tap(payButton);
    await tester.pump();

    expect(find.text('Please enter amount'), findsOneWidget);
    expect(find.text('Please enter first name'), findsOneWidget);
    expect(find.text('Please enter last name'), findsOneWidget);
    expect(find.text('Please enter email address'), findsOneWidget);
    expect(find.text('Please enter phone number'), findsOneWidget);
  });

  testWidgets('email validation test', (WidgetTester tester) async {
    await tester.pumpWidget(setupApp());

    await tester.enterText(email, 'vishal@yopmail');

    await tester.tap(payButton);
    await tester.pump();

    expect(find.text('Please enter valid email address'), findsOneWidget);
  });

  testWidgets('form verification test test', (WidgetTester tester) async {
    await tester.pumpWidget(setupApp());

    await tester.enterText(amount, '100');
    await tester.enterText(firstname, 'Vishal');
    await tester.enterText(lastname, 'golakiya');
    await tester.enterText(email, 'vishal@yopmail.com');
    await tester.enterText(phone, '9087123456');

    await tester.tap(payButton);
    await tester.pump();
  });
}
