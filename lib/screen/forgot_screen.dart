// ignore_for_file: use_build_context_synchronously

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/constant/string_constant.dart';
import 'package:qrscanner/repository/request.repository.dart';
import 'package:qrscanner/screen/signup_screen.dart';

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
        backgroundColor: Colors.green,
        title: const Text(StaticString.forgotPassword),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formForgotKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 50,
                  bottom: 15,
                ),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return StaticString.enterEmail;
                    } else if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value)) {
                      return StaticString.enterValidEmail;
                    } else {
                      return null;
                    }
                  },
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
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () async {
                  if (_formForgotKey.currentState!.validate()) {
                    try {
                      await sendEmailConfirmation(email);
                      Navigator.of(context).pop();
                      Flushbar(
                        title: StaticString.emailSent,
                        message: StaticString.emailSentMsg,
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          size: 28.0,
                          color: Colors.green,
                        ),
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    } catch (e) {
                      Flushbar(
                        title: StaticString.emailNotFound,
                        message: StaticString.signupNow,
                        icon: const Icon(
                          Icons.error,
                          size: 28.0,
                          color: Colors.red,
                        ),
                        duration: const Duration(seconds: 3),
                      ).show(context);
                    }
                  }
                },
                child: const Text(
                  StaticString.resetPassword,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupScreen(),
                    ),
                  );
                },
                child: const Text(
                  StaticString.newUserCreateAccount,
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
