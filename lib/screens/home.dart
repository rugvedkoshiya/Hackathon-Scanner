import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// ignore: import_of_legacy_library_into_null_safe
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hacktata/main.dart';
import 'package:hacktata/screens/login.dart';
import 'package:hacktata/screens/profile.dart';
import 'package:hacktata/screens/settings.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';
import 'package:vibration/vibration.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
final firestorage = FirebaseStorage.instance;

String userEmail = 'username@example.com';
var userUid = firebaseAuth.currentUser!.uid;
var profileLink =
    "https://firebasestorage.googleapis.com/v0/b/hackathon-mbit.appspot.com/o/profiles%2Fdummyprofile.png?alt=media&token=b300eaeb-70aa-40ba-8a49-0a141ea10602";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String qrresult = 'Unknown';
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();

  Widget deleteBG() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  Widget copyElement() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 20.0),
      color: Colors.green,
      child: const Icon(
        Icons.copy,
        color: Colors.white,
      ),
    );
  }

  Future<bool> conformDismiss(DismissDirection direction, index) async {
    if (direction == DismissDirection.endToStart) {
      return await showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              content: Text("Are you sure you want to Delete?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: Text("Ok"),
                  onPressed: () {
                    // Dismiss the dialog and
                    // also dismiss the swiped item
                    Navigator.of(context).pop(true);
                  },
                ),
                CupertinoDialogAction(
                  child: Text('Cancel'),
                  onPressed: () {
                    // Dismiss the dialog but don't
                    // dismiss the swiped item
                    return Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ) ??
          false;
    } else {
      var copydata = userData['scanResult'][index];
      Clipboard.setData(new ClipboardData(text: copydata));
      print("jakkas");
      Fluttertoast.showToast(
        msg: "Copied!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  try {
                    print("have error avshe?");
                    profileLink = await firestorage
                        .ref('profiles/$userUid.png')
                        .getDownloadURL();
                    print(profileLink);
                  } on FirebaseException catch (e) {
                    print("gaya");
                  } catch (e) {
                    print("hmm");
                  }
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                }),
            ListTile(
              leading: Icon(Icons.devices),
              title: Text("Devices"),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => Home()),
                // );
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
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
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          User user = firebaseAuth.currentUser!;
          await firestore.collection("users").doc(user.uid).get().then((value) {
            userData = value.data()!;
          });
          setState(() {});
        },
        child: Container(
          child: ListView.builder(
            // reverse: true,
            // shrinkWrap: true,
            padding: EdgeInsets.all(20.0),
            itemCount: userData['scanResult'].length,
            itemBuilder: (context, index) {
              return new Dismissible(
                key: UniqueKey(),
                confirmDismiss: (direction) => conformDismiss(direction, index),
                // key: Key(userData[index]),
                onDismissed: (direction) async {
                  String action;
                  if (direction == DismissDirection.endToStart) {
                    print(userData);
                    var deletedElement = userData['scanResult'][index];
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("Deleted Successfully !!"),
                    ));
                    await firestore
                        .collection("users")
                        .doc(firebaseAuth.currentUser!.uid.toString())
                        .update({
                      "scanResult": FieldValue.arrayRemove([deletedElement])
                    });
                    await userData['scanResult'].removeAt(index);
                    setState(() {});
                    // setState(() {
                    //   Scaffold.of(context).showSnackBar(SnackBar(
                    //     content: Text("Deleted Successfully !!"),
                    //     // action: SnackBarAction(
                    //     //   label: "UNDO",
                    //     //   onPressed: () {
                    //     //     firestore
                    //     //         .collection("users")
                    //     //         .doc(firebaseAuth.currentUser!.uid.toString())
                    //     //         .update({
                    //     //       "scanResult":
                    //     //           FieldValue.arrayUnion([deletedElement]),
                    //     //     });
                    //     //     setState(() {
                    //     //       userData['scanResult']
                    //     //           .insert(index, deletedElement);
                    //     //     });
                    //     //   },
                    //     // ),
                    //   ));
                    // });
                  } else if (direction == DismissDirection.startToEnd) {
                    print("copy");
                  }
                },
                background: copyElement(),
                secondaryBackground: deleteBG(),
                child: Card(
                  child: ListTile(
                    title: Text(userData['scanResult'][index]),
                  ),
                  // child: Stack(
                  //   children: <Widget>[
                  //     Container(
                  //         height: 100,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(24),
                  //             color: Colors.green.shade200,
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: Colors.green.shade200,
                  //                 blurRadius: 12,
                  //                 offset: Offset(0, 6),
                  //               ),
                  //             ])),
                  //     Padding(
                  //       padding: const EdgeInsets.all(15),
                  //       child: Row(
                  //         children: <Widget>[
                  //           Column(
                  //             mainAxisSize: MainAxisSize.min,
                  //             children: <Widget>[
                  //               Text(
                  //                 userData['scanResult'][index],
                  //                 style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontWeight: FontWeight.w500,
                  //                 ),
                  //               )
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   print("QR pressed");
        // },
        onPressed: () async {
          try {
            bool soundONbool;
            bool vibrationONbool;
            final qrCode = await BarcodeScanner.scan();
            SharedPreferences prefsSound =
                await SharedPreferences.getInstance();
            SharedPreferences prefsVibration =
                await SharedPreferences.getInstance();
            print("kaikala");
            try {
              soundONbool = prefsSound.getBool("userSoundSettingState")!;
              vibrationONbool = prefsVibration.getBool("userVibrationSettingState")!;
            } catch (e) {
              print("setting ma jao pela");
              soundONbool = false;
              vibrationONbool = false;
            }
            print(soundONbool);
            print(vibrationONbool);
            if (soundONbool) {
              Soundpool beepQR = Soundpool(streamType: StreamType.notification);
              int soundId = await rootBundle
                  .load("assets/sounds/beep.ogg")
                  .then((ByteData soundData) {
                return beepQR.load(soundData);
              });
              await beepQR.play(soundId);
            }
            if (vibrationONbool) {
              print("vagshe");
              if (await Vibration.hasVibrator()) {
                if (await Vibration.hasCustomVibrationsSupport()) {
                  Vibration.vibrate(duration: 300);
                } else {
                  Vibration.vibrate();
                }
              }
              // HapticFeedback.heavyImpact();
            }

            setState(() {
              this.qrresult = qrCode;
            });
            print(qrCode);
            CollectionReference users = await firestore.collection('users');
            await firestore
                .collection("users")
                .doc(firebaseAuth.currentUser!.uid.toString())
                .update({
              "scanResult": FieldValue.arrayUnion([qrresult]),
            });
            User user = firebaseAuth.currentUser!;
            await firestore
                .collection("users")
                .doc(user.uid)
                .get()
                .then((value) {
              userData = value.data()!;
              print(userData);
            });
            setState(() {
              userData = userData;
              print("done11");
            });
          } on PlatformException catch (e) {
            if (e.code == BarcodeScanner.CameraAccessDenied) {
              setState(() {
                this.qrresult = 'No camera permission!';
              });
            } else {
              setState(() => this.qrresult = 'Unknown error: $e');
            }
          } on FormatException {
            setState(() => this.qrresult = 'Nothing captured.');
          } catch (e) {
            setState(() => this.qrresult = 'Unknown error: $e');
          }

          // try {
          //   print("done1");
          //   final qrCode = await FlutterBarcodeScanner.scanBarcode(
          //     '#ff6666',
          //     'Cancel',
          //     true,
          //     ScanMode.QR,
          //   );
          //   print("done2");

          //   if (!mounted) return;
          //   print("done3");

          //   setState(() {
          //     print("done4");
          //     this.qrresult = qrCode;
          //   });
          //   print("done5");
          //   if (qrresult != "-1") {
          //     print("done6");
          //     CollectionReference users = await firestore.collection('users');
          //     print("done7");
          //     await firestore
          //         .collection("users")
          //         .doc(firebaseAuth.currentUser!.uid.toString())
          //         .update({
          //       "scanResult": FieldValue.arrayUnion([qrresult]),
          //     });
          //     print("done8");
          //   }
          //   // print("SSuccess!");
          //   User user = firebaseAuth.currentUser!;
          //   print("done9");
          //   await firestore
          //       .collection("users")
          //       .doc(user.uid)
          //       .get()
          //       .then((value) {
          //     userData = value.data()!;
          //     // print(userData);
          //   });
          //   print("done10");
          //   setState(() {
          //     userData = userData;
          //     print("done11");
          //   });
          // } on PlatformException {
          //   qrresult = 'Failed to get platform version.';
          // }
        },
        backgroundColor: Colors.green.shade400,
        child: Icon(Icons.camera_alt),
        tooltip: "Scan DATA Matrix",
      ),
    );
  }
}
