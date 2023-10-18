# Auropay sandbox Plugin.


## Getting Started

AuroPay Payments Flutter SDK/plugin allows you to accept in-app payments by providing you with the building blocks you need, to create a checkout experience for iOS and Android SDK.


# Pubspec.yaml Setup

To add AuroPay Flutter plugin into your project from Pub.dev, follow the steps below.

Add the code given below to your project's pubspec.yaml file, if not already added.
```yaml
auropay_payments_sandbox: ^1.0.0
```
Or run in terminal
```
    $ flutter pub add auropay_payments_sandbox
```

Run in terminal
```
    $ flutter pub get
```

Now, the AuroPay Plugin will be added into your project.

Note: for Android, it is required to add internet permission in manifest file
```xml
    <uses-permission android:name="android.permission.INTERNET"/> 
```

For iOS Add camera permission in info.plist file
```xml
    <key>NSCameraUsageDescription</key>
    <string>Needs access to your camera to scan your card.</string>
```


# Using The SDK

To use the AuroPay Flutter plugin for payment transactions the SDK should be initialized prior to initiating any payment request. The AuroPay SDK can be initialized from main.dart

# Initialize SDK

Construct the required model classes to initialize the SDK. Add the following lines in your Activity or fragment.
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

Optionally you can also specify a theme for the AuroPay Android SDK UI elements to match your application theme.

```dart
// Create the theme model.
Theme myThemeobj = AuropayTheme(
primaryColor: const Color(0xff236C6C),
colorOnPrimary: Colors.black,
colorOnSecondary: Colors.redAccent,
secondaryColor: Colors.white);

builder.setTheme(myThemeobj)

```

Initiate Payment Request and Consume Result
Following code snippet demonstrates how to initiate a payment request and receive callback events

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

We can have more detailed payment result from the SDK by setting parameter in builder

```dart
  builder.getDetailedResponse(true) // default it is false
```

Then doPayment response will be SuccessDetail.

By following the steps outlined in this document, you should be able to successfully integrate the AuroPay Flutter plugin into your mobile application and process payments seamlessly.
If you are facing any trouble, reach out to us at support@auropay.net
