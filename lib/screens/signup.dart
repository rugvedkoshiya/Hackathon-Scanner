// ignore: import_of_legacy_library_into_null_safe
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacktata/screens/login.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class _SignupState extends State<Signup> {
  String _email = "";
  String _password = "";
  String _confPassword = "";
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text("Hackathon Signup"),
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
                  // autovalidate: true,
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
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 15),
                child: TextFormField(
                  validator: (value) {
                    if (value != _password) {
                      return "Password does not match";
                    }
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Conform Password',
                      hintText: 'Enter password again'),
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(20)),
                // ignore: deprecated_member_use
                child: FlatButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      try {
                        UserCredential userCredential =
                            await firebaseAuth.createUserWithEmailAndPassword(
                                email: _email, password: _password);
                        User user = firebaseAuth.currentUser!;
                        if (!user.emailVerified) {
                          await user.sendEmailVerification();
                        }
                        // print("Registered Successfully");
                        CollectionReference users =
                            await firestore.collection('users');
                        String uid =
                            await firebaseAuth.currentUser!.uid.toString();
                        // print(uid);
                        // print(users);
                        final result = await users.doc(uid).get();
                        // print(result);
                        // print(users.get());
                        await firestore.collection("users").doc(uid).set({
                          "displayName": "",
                          "mobileNo": int.parse("0"),
                          "scanResult": [],
                        }, SetOptions(merge: true)).then((_) {
                          // print("SSuccess!");
                        });
                        await firebaseAuth.signOut();
                        Navigator.of(context).pop();
                        Flushbar(
                          title: "Successfully Registerd",
                          message: "Now Login to Proceed!",
                          icon: Icon(
                            Icons.check_circle_rounded,
                            size: 28.0,
                            color: Colors.green,
                          ),
                          duration: Duration(seconds: 3),
                        )..show(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          // print('The password provided is too weak.');
                          Flushbar(
                            title: "Weak Password!!",
                            message: "try to make secure password",
                            icon: Icon(
                              Icons.error,
                              size: 28.0,
                              color: Colors.red,
                            ),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        } else if (e.code == 'email-already-in-use') {
                          // print('The account already exists for that email.');
                          Flushbar(
                            title: "Account Exist!!",
                            message: "this email is already exist! try Login",
                            icon: Icon(
                              Icons.error,
                              size: 28.0,
                              color: Colors.red,
                            ),
                            duration: Duration(seconds: 3),
                          )..show(context);
                        }
                      } catch (e) {
                        // print(e);
                      }
                    } else {
                      // print("not success");
                    }
                  },
                  child: Text(
                    'Signup',
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              // ignore: deprecated_member_use
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
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
}

class SnackbarButton extends StatelessWidget {
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return RaisedButton(
      onPressed: () {
        final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Text label'),
          action: SnackBarAction(
            label: 'Action',
            onPressed: () {},
          ),
        );

        // Find the Scaffold in the widget tree and use
        // it to show a SnackBar.
        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(snackBar);
      },
      child: Text('Show SnackBar'),
    );
  }
}
