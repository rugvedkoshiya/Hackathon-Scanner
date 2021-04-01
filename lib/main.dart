import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacktata/screens/login.dart';
import 'package:hacktata/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
var userData = {};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (firebaseAuth.currentUser != null && firebaseAuth.currentUser.emailVerified) {
    User user = firebaseAuth.currentUser!;
    userEmail = user.email!;
    await firestore.collection("users").doc(user.uid).get().then((value) {
      userData = value.data()!;
      // print(userData);
      // print(userData['scanResult'].length);
    });
    runApp(MyAppLogedIn());
  } else {
    // print("Koi nahi he");
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Login(),
    );
  }
}

class MyAppLogedIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Home(),
    );
  }
}
