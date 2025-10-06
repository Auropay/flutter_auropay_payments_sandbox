import 'package:auropay_payments_sandbox/auropay_payments.dart';
import 'package:auropay_payments_sandbox/models/auropay_builder.dart';
import 'package:auropay_payments_sandbox/models/auropay_response.dart';
import 'package:flutter/material.dart';

// remove blow line or
// create your own keys.dart file for merchantID, accessKey and secretKey
import 'package:auropay_payments_sandbox_example/keys.dart' as keys;

class SimpleApp extends StatelessWidget {
  const SimpleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: false,
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: Colors.blue)),
      home: const SimpleView(),
    );
  }
}

class SimpleView extends StatefulWidget {
  const SimpleView({super.key});

  @override
  State<SimpleView> createState() => _SimpleViewState();
}

class _SimpleViewState extends State<SimpleView> {
  final formKey = GlobalKey<FormState>();

  final amountController = TextEditingController();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final firstnameFocus = FocusNode();
  final lastnameFocus = FocusNode();
  final emailFocus = FocusNode();
  final phoneFocus = FocusNode();

  // Step 1: Initialise Auropay
  final _auropay = AuropayPayments();
  bool _isShowLoader = false;
  PaymentStatus _paymentStatus = PaymentStatus.init;
  AuropayResponse? auropayResponse;

  // Launch native payment view
  Future<void> _startPayment(CustomerProfile customerProfile) async {
    setState(() {
      _isShowLoader = true;
    });

    // Step 2: prepare builder with required information
    final builder = AuropayBuilder(
            // your merchant domain name from auropay merchant portal
            subDomainId: keys.yourSubDomainId,
            // your access key from auropay merchant portal
            accessKey: keys.yourAccessKey,
            // your secret key from auropay merchant portal
            secretKey: keys.yourSecretKey,
            customerProfile: customerProfile)
        .setShowReceipt(true) // default true
        .askForCustomerDetail(false) // default false
        .getDetailedResponse(false) // default false
        .build();

    try {
      // Step 3: Call doPayment
      auropayResponse = await _auropay.doPayment(
          builder: builder,
          amount: double.parse(amountController.text),
          /*referenceNumber: "xyz_reference_1"*/);
      debugPrint("auroPay response :: ${auropayResponse.toString()}");

      setState(() {
        _paymentStatus = ResponseType.success == auropayResponse?.type
            ? PaymentStatus.success
            : PaymentStatus.failed;
        _isShowLoader = false;

        // Step 4: Handle response
        String? message;
        if (auropayResponse?.data is FailureData) {
          FailureData data = auropayResponse?.data as FailureData;
          message = 'Payment Failed:\n${data.message}';
        }

        // when getDetailedResponse == false
        if (auropayResponse?.data is SuccessData) {
          SuccessData data = auropayResponse?.data as SuccessData;
          message = 'Payment Success\nTransaction Id: ${data.transactionId}';
        }

        // when getDetailedResponse == true
        if (auropayResponse?.data is SuccessDetail) {
          SuccessDetail data = auropayResponse?.data as SuccessDetail;
          message = 'Payment Success\nTransaction Id: ${data.transactionId}';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_paymentStatus == PaymentStatus.success
                ? message ?? 'Payment Success'
                : message ?? 'Payment Failed')));
      });
    } on Exception catch (e) {
      debugPrint('auroPay response :: $e');
      setState(() {
        _isShowLoader = false;
        _paymentStatus = PaymentStatus.failed;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Payment Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AuroPay Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                key: const ValueKey('tff_mount'),
                controller: amountController,
                decoration: decoration('Amount'),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(firstnameFocus);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = double.parse(value);
                  if (amount <= 0) {
                    return 'Please enter valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('tff_firstname'),
                controller: firstnameController,
                decoration: decoration('First Name'),
                focusNode: firstnameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(lastnameFocus);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('tff_lastname'),
                controller: lastnameController,
                decoration: decoration('Last Name'),
                focusNode: lastnameFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(emailFocus);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('tff_email'),
                controller: emailController,
                decoration: decoration('Email'),
                keyboardType: TextInputType.emailAddress,
                focusNode: emailFocus,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(phoneFocus);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter email address';
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Please enter valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const ValueKey('tff_phone'),
                controller: phoneController,
                decoration: decoration('Phone Number'),
                keyboardType: TextInputType.phone,
                focusNode: phoneFocus,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                  height: 48,
                  width: MediaQuery.sizeOf(context).width,
                  child: ElevatedButton(
                      key: const ValueKey('button_pay'),
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          _startPayment(CustomerProfile(
                            title: '',
                            firstName: firstnameController.text,
                            middleName: "",
                            lastName: lastnameController.text,
                            phone: phoneController.text,
                            email: emailController.text,
                          ));
                        }
                      },
                      child: _isShowLoader
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Pay',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.white),
                            )))
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration decoration(String label) {
    return InputDecoration(
        border: const OutlineInputBorder(), label: Text(label));
  }
}

enum PaymentStatus { init, success, failed }
