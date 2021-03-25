// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacktata/screens/forgotpass.dart';
import 'package:hacktata/screens/home.dart';
import 'package:hacktata/screens/signup.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class _LoginState extends State<Login> {
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text("Hackathon Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    child: Image.asset('assets/images/flutter_horizontal.png')),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email'),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                onChanged: (value) {
                  setState(() {
                    password = value;
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
                  color: Colors.green, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Home()),
                  // );
                  try {
                    UserCredential userCredential =
                        await firebaseAuth.signInWithEmailAndPassword(
                            email: email, password: password);
                    User user = FirebaseAuth.instance.currentUser;

                    // if (!user.emailVerified) {
                    //   await user.sendEmailVerification();
                    // }
                    if (firebaseAuth.currentUser != null) {
                      print(firebaseAuth.currentUser.email);

                    }
                    setState(() {
                      userEmail = firebaseAuth.currentUser.email;
                    });
                    // FirebaseUser user = FirebaseAuth.getInstance().getCurrentUser();
                    print("loggedinn");
                    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User user) {
                      if (user == null) {
                        print('User is currently signed out!');
                      } else {
                        print('User is signed in!');
                      }
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
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
    );
  }
}
