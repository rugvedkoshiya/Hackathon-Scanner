// ignore: import_of_legacy_library_into_null_safe
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacktata/main.dart';
import 'package:hacktata/screens/forgotpass.dart';
import 'package:hacktata/screens/home.dart';
import 'package:hacktata/screens/signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;

class _LoginState extends State<Login> {
  String _email = "";
  String _password = "";
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text("Hackathon Login"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      child:
                          Image.asset('assets/images/flutter_horizontal.png')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Email";
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return "Enter Valid Email";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (email) {
                    _email = email!;
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid email'),
                  onChanged: (value) {
                    setState(() {
                      _email = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "* Required";
                    } else if (value.length < 6) {
                      return "Password should be atleast 6 characters";
                    } else if (value.length > 15) {
                      return "Password should not be greater than 15 characters";
                    } else
                      return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                ),
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Forgot()),
                  );
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.green, fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      try {
                        await firebaseAuth.signInWithEmailAndPassword(
                            email: _email, password: _password);
                        User user = firebaseAuth.currentUser!;
                        if (user.emailVerified) {
                          if (firebaseAuth.currentUser != null) {
                            // print(firebaseAuth.currentUser!.email);
                          }
                          setState(() {
                            userEmail = firebaseAuth.currentUser!.email!;
                          });
                          // print("loggedinn");
                          if (firebaseAuth.currentUser != null) {
                            User user = firebaseAuth.currentUser!;
                            // print(user.email);
                            // print(user.emailVerified);
                            userEmail = user.email!;
                            await firestore
                                .collection("users")
                                .doc(user.uid)
                                .get()
                                .then((value) {
                              userData = value.data()!;
                              // print(userData);
                            });
                          }
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
                        } else {
                          await firebaseAuth.signOut();
                          showDialog(
                              context: context,
                              builder: (BuildContext contex) {
                                return AlertDialog(
                                  title: Text("Verify Your Email"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 25),
                                          child: Text(
                                            "A verification mail has been sent to your email",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                );
                              });
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          // print('No user found for that email.');
                          Flushbar(
                            title: "User Not Found !",
                            message: "Email is not registerd! Signup now",
                            icon: Icon(
                              Icons.error,
                              size: 28.0,
                              color: Colors.red,
                            ),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        } else if (e.code == 'wrong-password') {
                          // print('Wrong password provided for that user.');
                          Flushbar(
                            title: "Wrong Password !",
                            message: "Forgot password for recovery",
                            icon: Icon(
                              Icons.error,
                              size: 28.0,
                              color: Colors.red,
                            ),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        }
                      }
                    } else {
                      // print("Na munna na");
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 130,
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
                child: Text(
                  'New User? Create Account',
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
