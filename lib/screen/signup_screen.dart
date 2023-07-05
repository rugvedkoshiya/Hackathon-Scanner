// ignore_for_file: use_build_context_synchronously, empty_catches

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/constant/firebase_constant.dart';

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
        backgroundColor: Colors.green,
        title: const Text("Signup"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                // autovalidate: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Enter Email";
                  } else if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value)) {
                    return "Enter Valid Email";
                  } else {
                    return null;
                  }
                },
                onSaved: (email) {
                  _email = email!;
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email_rounded),
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email',
                ),
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else if (value.length < 6) {
                    return "Password should be atleast 6 characters";
                  } else if (value.length > 15) {
                    return "Password should not be greater than 15 characters";
                  } else {
                    return null;
                  }
                },
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.password_rounded),
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter secure password',
                ),
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                validator: (value) {
                  if (value != _password) {
                    return "Password does not match";
                  }
                  return null;
                },
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.password_rounded),
                  border: OutlineInputBorder(),
                  labelText: 'Conform Password',
                  hintText: 'Enter password again',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: submitFunc,
                child: const Text(
                  'Signup',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Already have an account? Login',
                  style: TextStyle(color: Colors.green, fontSize: 15),
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
