// ignore_for_file: use_build_context_synchronously

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/constant/string_constant.dart';
import 'package:qrscanner/repository/request.repository.dart';
import 'package:qrscanner/screen/signup_screen.dart';
import 'package:qrscanner/utils/custom_extension.dart';
import 'package:qrscanner/widget/cust_elevated_button.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final GlobalKey<FormState> _formForgotKey = GlobalKey<FormState>();
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(StaticString.forgotPassword),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formForgotKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (value) => value?.validateEmail,
                onSaved: (value) {
                  email = value!;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: StaticString.email,
                  hintText: StaticString.enterYourEmail,
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              CustElevatedButton(
                onPressed: submitFunc,
                btnText: StaticString.resetPassword,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: Text(
                  StaticString.newUserCreateAccount,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitFunc() async {
    if (_formForgotKey.currentState!.validate()) {
      try {
        await sendEmailConfirmation(email);
        Navigator.of(context).pop();
        Flushbar(
          title: StaticString.emailSent,
          message: StaticString.emailSentMsg,
          icon: Icon(
            Icons.check_circle_outline_rounded,
            size: 28.0,
            color: Theme.of(context).colorScheme.primary,
          ),
          duration: const Duration(seconds: 3),
        ).show(context);
      } catch (e) {
        Flushbar(
          title: StaticString.emailNotFound,
          message: StaticString.signupNow,
          icon: Icon(
            Icons.error,
            size: 28.0,
            color: Theme.of(context).colorScheme.error,
          ),
          duration: const Duration(seconds: 3),
        ).show(context);
      }
    }
  }
}
