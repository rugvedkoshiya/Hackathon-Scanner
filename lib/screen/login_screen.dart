// ignore_for_file: use_build_context_synchronously

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/constant/firebase_constant.dart';
import 'package:qrscanner/screen/forgot_screen.dart';
import 'package:qrscanner/screen/home_screen.dart';
import 'package:qrscanner/screen/signup_screen.dart';
import 'package:qrscanner/utils/custom_extension.dart';

import '../gen/app_localizations.dart';
import '../widget/cust_elevated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Variables
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).appName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              // Email field
              TextFormField(
                validator: (value) => value?.validateEmail,
                onSaved: (email) {
                  _email = email!;
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_rounded),
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).email,
                  hintText: AppLocalizations.of(context).emailHint,
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Password field
              TextFormField(
                validator: (value) => value?.validatePassword,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_rounded),
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).password,
                  hintText: AppLocalizations.of(context).passwordHint,
                ),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              const SizedBox(height: 10),

              // Forgot password field
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotScreen(),
                        ),
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context).forgotPassword,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Login button
              CustElevatedButton(
                onPressed: submitFunc,
                btnText: AppLocalizations.of(context).login,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context).newUserCreateAccount,
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
    if (_formkey.currentState!.validate()) {
      try {
        await firebaseAuth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        final User user = firebaseAuth.currentUser!;
        if (user.emailVerified) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          user.sendEmailVerification();
          await firebaseAuth.signOut();
          setState(() {});
          showDialog(
            context: context,
            builder: (BuildContext contex) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context).verifyYourEmail),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Text(
                        AppLocalizations.of(context).verifyYourEmailMsg,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      } on FirebaseAuthException catch (e) {
        final Widget icon = Icon(
          Icons.error,
          size: 28.0,
          color: Theme.of(context).colorScheme.error,
        );
        const Duration duration = Duration(seconds: 3);
        if (e.code == 'user-not-found') {
          Flushbar(
            title: "User Not Found !",
            message: "Email is not registerd! Signup now",
            icon: icon,
            duration: duration,
          ).show(context);
        } else if (e.code == 'wrong-password') {
          Flushbar(
            title: "Wrong Password !",
            message: "Forgot password for recovery",
            icon: icon,
            duration: duration,
          ).show(context);
        } else if (e.code == 'too-many-requests') {
          Flushbar(
            title: "Too Many Requests !",
            message: "Try after some time",
            icon: icon,
            duration: duration,
          ).show(context);
        } else {
          Flushbar(
            title: "Internal Error !",
            message: "Try after some time",
            icon: icon,
            duration: duration,
          ).show(context);
        }
      }
    }
  }
}
