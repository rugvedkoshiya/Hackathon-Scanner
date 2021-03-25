import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hacktata/screens/login.dart';
import 'package:hacktata/screens/profile.dart';
import 'package:hacktata/screens/settings.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:settings_ui/settings_ui.dart';
// import 'package:custom_switch/custom_switch.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
String userEmail = 'Not Available';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String qrresult = 'Unknown';

  @override
  Widget build(BuildContext context) {
    // final GlobalKey _scaffoldKey = new GlobalKey();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.green.shade400,
          title: Text("Hackathon Scanner"),
          // actions: <Widget>[
          //   IconButton(icon: Icon(Icons.home), onPressed: () => debugPrint("Homepage chhe aa"),)
          // ],
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
                  // child: Text("LIST SETTINGS"),
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
                  // onTap: () => debugPrint("Profile"),
                  onTap: () {
                    // Navigator.of(context).pop();
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
                  // Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () async {
                  await firebaseAuth.signOut();
                  Navigator.of(context).pop();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => Login()),
                  // );
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  '$qrresult',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  '$userEmail',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
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
