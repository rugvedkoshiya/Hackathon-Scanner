// ignore_for_file: use_build_context_synchronously, empty_catches

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/constant/firebase_constant.dart';
import 'package:qrscanner/screen/login_screen.dart';
import 'package:qrscanner/utils/custom_extension.dart';
import 'package:qrscanner/widget/cust_elevated_button.dart';

import '../gen/app_localizations.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
          AppLocalizations.of(context).signup,
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
              TextFormField(
                // autovalidate: true,
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
              TextFormField(
                validator: (value) => value?.validateConfrimPassword(
                  confirmPasswordVal: _password,
                ),
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_rounded),
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context).confirmPassword,
                  hintText: AppLocalizations.of(context).confirmPasswordHint,
                ),
              ),
              const SizedBox(height: 30),
              CustElevatedButton(
                onPressed: submitFunc,
                btnText: AppLocalizations.of(context).signup,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  AppLocalizations.of(context).alreadyHavenAnAccountLogin,
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
        final UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        final User user = userCredential.user!;
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
        await fireStore.collection("users").doc(user.uid).set(
          {
            "displayName": "",
            "mobileNo": int.parse("0"),
            "scanResult": [],
          },
          SetOptions(merge: true),
        );
        await firebaseAuth.signOut();
        Navigator.of(context).pop();
        Flushbar(
          title: "Successfully Registerd",
          message: "Verify your Email for Login",
          icon: const Icon(
            Icons.check_circle_rounded,
            size: 28.0,
            color: Colors.green,
          ),
          duration: const Duration(seconds: 3),
        ).show(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Flushbar(
            title: "Weak Password!!",
            message: "Try to make secure password",
            icon: const Icon(
              Icons.error,
              size: 28.0,
              color: Colors.red,
            ),
            duration: const Duration(seconds: 3),
          ).show(context);
        } else if (e.code == 'email-already-in-use') {
          Flushbar(
            title: "Account Exist!!",
            message: "This email is already exist! try Login",
            icon: const Icon(
              Icons.error,
              size: 28.0,
              color: Colors.red,
            ),
            duration: const Duration(seconds: 3),
          ).show(context);
        }
      } catch (e) {}
    }
  }
}
