import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hacktata/main.dart';
import 'package:hacktata/screens/login.dart';
import 'package:hacktata/screens/profile.dart';
import 'package:hacktata/screens/settings.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
String userEmail = 'username@example.com';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String qrresult = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade400,
          title: Text("Hackathon Scanner"),
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Stack(children: <Widget>[
                    Positioned(
                        bottom: 12.0,
                        left: 16.0,
                        child: Text("Hackathon Scanner",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500))),
                  ])),
              ListTile(
                  leading: Icon(Icons.person),
                  title: Text("Profile"),
                  onTap: () async {
                    User user = firebaseAuth.currentUser!;
                    userEmail = firebaseAuth.currentUser!.email!;
                    await firestore
                        .collection("users")
                        .doc(firebaseAuth.currentUser!.uid)
                        .get()
                        .then((value) async {
                      // print(value.data());
                      displayName = value.data()!['displayName'];
                      mobileNo = value.data()!['mobileNo'].toString();
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    );
                  }),
              ListTile(
                leading: Icon(Icons.devices),
                title: Text("Devices"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Setting()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () async {
                  await firebaseAuth.signOut();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: userData['scanResult'].length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: <Widget>[
                            Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    color: Colors.green.shade200,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.green.shade200,
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ])),
                            Padding(
                              padding: const EdgeInsets.all(15),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        userData['scanResult'][index],
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              final qrCode = await FlutterBarcodeScanner.scanBarcode(
                '#ff6666',
                'Cancel',
                true,
                ScanMode.QR,
              );

              if (!mounted) return;

              setState(() {
                this.qrresult = qrCode;
              });
              if (qrresult != "-1") {
                CollectionReference users = await firestore.collection('users');
                await firestore
                    .collection("users")
                    .doc(firebaseAuth.currentUser!.uid.toString())
                    .update({
                  "scanResult": FieldValue.arrayUnion([qrresult]),
                });
              }
              // print("SSuccess!");
              User user = firebaseAuth.currentUser!;
              await firestore
                  .collection("users")
                  .doc(user.uid)
                  .get()
                  .then((value) {
                userData = value.data()!;
                // print(userData);
              });
              setState(() {
                userData = userData;
              });
            } on PlatformException {
              qrresult = 'Failed to get platform version.';
            }
          },
          backgroundColor: Colors.green.shade400,
          child: Icon(Icons.camera_alt),
          tooltip: "Scan DATA Matrix",
        ),
      ),
    );
  }
}
