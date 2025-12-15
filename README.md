# Auropay sandbox Plugin.

## Getting Started

AuroPay plugin allows you to accept in-app payments providing you with the building blocks, to create a seamless checkout experience for iOS and Android apps.


## Pubspec.yaml Setup

To add AuroPay Flutter plugin to your project from Pub.dev, follow the below steps.

Step-1.  Add the code given below to your project's pubspec.yaml file, if this is not already added.
```
dependencies:
  auropay_payments_sandbox: latest_version
  
// or run in terminal
$ flutter pub add auropay_payments_sandbox
```

Step- 2. Run in terminal
```
    $ flutter pub get
```

Now, the AuroPay plugin will be added to your project.

Note: for Android, it is required to add internet permission in the manifest file
```xml
    <uses-permission android:name="android.permission.INTERNET"/> 
```

For iOS add camera permission and upi intent list in info.plist file
```xml
    <key>NSCameraUsageDescription</key>
    <string>Needs access to your camera to scan your card.</string>
    <key>LSApplicationQueriesSchemes</key>
    <array>
        <string>phonepe</string>
        <string>tez</string>
        <string>paytmmp</string>
    </array>
```


## Using SDK
To use the AuroPay Flutter plugin for payment transactions the SDK should be initialized prior to initiating any payment request. The AuroPay Plugin can be initialized from main.dart

## Initialize SDK
Construct the required model classes to initialize the plugin, add the following lines in your dart file.
```dart
// Create customer profile.
CustomerProfile customerProfileobj = CustomerProfile(
    title: "Some Title",
    firstName: "First Name",
    middleName: "Middle Name",
    lastName: "Last Name",
    phone: "01234567890",
    email: "Test@gmail.com");

// prepare builder with required information
final builder = AuropayBuilder(
    subDomainId: keys.merchantId, // your merchant domain name
    accessKey: keys.accessKey, // your access key
    secretKey: keys.secretKey, // your secret key
    customerProfile: customerProfile)
    .setAutoContrast(true) // color theme setup for appbar
    .setCountry(Country.IN)
    .setShowReceipt(true)
    .askForCustomerDetail(false)
    .getDetailedResponse(false)
    .build();
```

Optionally you can also specify a theme for the AuroPay plugin UI elements to match your application theme.
```dart
// Create the theme model.
Theme myTheme = AuropayTheme(
    primaryColor: const Color(0xff236C6C),
    colorOnPrimary: Colors.black,
    colorOnSecondary: Colors.redAccent,
    secondaryColor: Colors.white);

builder.setTheme(myTheme);
```

## Initiate payment request and consume result
Following code snippet demonstrates how to initiate a payment request and receive callback events.
```dart
auropayResponse = await _auropay.doPayment(
    builder: builder,
    amount: double.parse(amountController.text),
    referenceNumber: "mock_reference");

final paymentStatus = ResponseType.success == auropayResponse?.type
    ? PaymentStatus.success 
    : PaymentStatus.failed; 

String? message;
if (auropayResponse?.data is FailureData) {
  FailureData data = auropayResponse?.data as FailureData;
  message = 'Payment Failed:\n${data.message}';
}

if (auropayResponse?.data is SuccessData) {
  SuccessData data = auropayResponse?.data as SuccessData;
  message = 'Payment Success\nTransaction Id: ${data.transactionId}';
}
```

You can get a detailed payment response from the SDK by setting the below parameter to 'true' in builder property.
```dart
  builder.getDetailedResponse(true) // default it is false
```

By following the steps outlined in this document, you should be able to successfully integrate the AuroPay Flutter plugin into your mobile application and process payments seamlessly.

If you are facing any trouble, reach out to us at support@auropay.net
