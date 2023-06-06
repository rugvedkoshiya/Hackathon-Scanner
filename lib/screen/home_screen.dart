// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrscanner/constant/firebase_constant.dart';
import 'package:qrscanner/constant/string_constant.dart';
import 'package:qrscanner/model/user_data_model.dart';
import 'package:qrscanner/repository/request.repository.dart';
import 'package:qrscanner/screen/login_screen.dart';
import 'package:qrscanner/screen/profile_screen.dart';
import 'package:qrscanner/screen/setting_screen.dart';
import 'package:qrscanner/widget/copy_widget.dart';
import 'package:qrscanner/widget/delete_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soundpool/soundpool.dart';

import '../gen/assets.gen.dart';

String userEmail = 'username@example.com';
String userUid = firebaseAuth.currentUser!.uid;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey =
      GlobalKey<RefreshIndicatorState>();
  String qrResult = StaticString.unknown;

  Future<bool> confirmDismiss(DismissDirection direction, int index) async {
    if (direction == DismissDirection.endToStart) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(StaticString.delete),
          content: const Text(StaticString.deleteMsg),
          actions: <Widget>[
            TextButton(
              child: const Text(StaticString.cancel),
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text(StaticString.delete),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );
    } else {
      Clipboard.setData(ClipboardData(text: userData.scanResult[index]));
      Fluttertoast.showToast(
        msg: StaticString.copied,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(StaticString.appName),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text(
                      StaticString.appName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text(StaticString.profile),
              onTap: () async {
                final QRUserInfo profileData = await getProfileData();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      profileData: profileData,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.devices),
              title: const Text(StaticString.qrCodes),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text(StaticString.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(StaticString.logout),
              onTap: () async {
                await firebaseAuth.signOut();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await setData();
          setState(() {});
        },
        child: FutureBuilder<bool>(
          future: setData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: userData.scanResult.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    confirmDismiss: (direction) =>
                        confirmDismiss(direction, index),
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        Fluttertoast.showToast(
                          msg: StaticString.deleteSuccessMsg,
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                        );
                        await deleteData(index);
                        setState(() {
                          userData.scanResult.removeAt(index);
                          userData = userData;
                        });
                      }
                    },
                    background: copyElement(),
                    secondaryBackground: const DeleteCardWidget(),
                    child: Card(
                      child: ListTile(
                        title: Text(userData.scanResult[index]),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton(
          onPressed: () async {
            try {
              bool soundOnbool;
              bool vibrationOnbool;
              final ScanResult qrCode = await BarcodeScanner.scan();
              if (qrCode.rawContent != "") {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                soundOnbool = prefs.getBool("userSoundSettingState") ?? false;
                vibrationOnbool =
                    prefs.getBool("userVibrationSettingState") ?? false;
                if (soundOnbool) {
                  final Soundpool beepQR =
                      Soundpool(streamType: StreamType.ring);
                  final ByteData soundData = await rootBundle.load(Assets.sound.beep);
                  final int soundId = await beepQR.load(soundData);
                  beepQR.play(soundId);
                }
                if (vibrationOnbool) {
                  if (await Vibrate.canVibrate) {
                    Vibrate.feedback(FeedbackType.heavy);
                  }
                }
                final bool isAdded = await addData(qrCode.rawContent);
                if (!isAdded) {
                  Fluttertoast.showToast(
                    msg: StaticString.alreadyScanned,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
                setState(() {
                  userData = userData;
                });
              }
            } on PlatformException catch (e) {
              if (e.code == BarcodeScanner.cameraAccessDenied) {
                setState(() {
                  qrResult = StaticString.noCameraPermission;
                });
              } else {
                setState(() => qrResult = 'Unknown error: $e');
              }
            } on FormatException {
              setState(() => qrResult = StaticString.nothingCaptured);
            } catch (e) {
              setState(() => qrResult = 'Unknown error: $e');
            }
          },
          backgroundColor: Colors.green,
          tooltip: StaticString.scanQrCode,
          child: const Icon(Icons.camera_alt_rounded),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
