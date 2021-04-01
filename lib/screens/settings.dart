import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool soundON = false;
  bool vibrationON = false;

  @override
  void initState() {
    super.initState();
    getUserSetting();
  }

  getUserSetting() async {
    soundON = await getUserSoundSettingState();
    vibrationON = await getUserVibrationSettingState();
    setState(() {});
  }

  Future<bool> saveUserSoundSettingState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("userSoundSettingState", value);
    print('Sound Value saved $value');
    return prefs.setBool("userSoundSettingState", value);
  }

  Future<bool> saveUserVibrationSettingState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("userVibrationSettingState", value);
    print('Vibration Value saved $value');
    return prefs.setBool("userVibrationSettingState", value);
  }

  Future<bool> getUserSoundSettingState() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      soundON = prefs.getBool("userSoundSettingState")!;
    } catch (e) {
      saveUserSoundSettingState(false);
      soundON = false;
    }
    return soundON;
  }

  Future<bool> getUserVibrationSettingState() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      vibrationON = prefs.getBool("userVibrationSettingState")!;
    } catch (e) {
      saveUserVibrationSettingState(false);
      vibrationON = false;
    }
    return vibrationON;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text("Hackathon Settings"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Conf",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Beep Sound",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Switch(
                  value: soundON,
                  onChanged: (value) {
                    setState(() {
                      soundON = value;
                      saveUserSoundSettingState(value);
                      // print(soundON);
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Vibration",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Switch(
                  value: vibrationON,
                  onChanged: (value) {
                    setState(() {
                      vibrationON = value;
                      saveUserVibrationSettingState(value);
                      // print(vibrationON);
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Misc",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            ListTile(
                // leading: Icon(Icons.policy),
                title: Text("Privacy Policy"),
                trailing: Icon(Icons.policy),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Privacy Policy"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                  "If you use this app then we can do anything in your mobile :)"),
                              Text("It's Prank"),
                            ],
                          ),
                          actions: [
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close"),
                            ),
                          ],
                        );
                      });
                }),
            SizedBox(
              height: 20,
            ),
            ListTile(
                // leading: Icon(Icons.info),
                title: Text("About US"),
                trailing: Icon(Icons.info),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("About US"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Why you want to know about us :)"),
                              Text("Why??"),
                            ],
                          ),
                          actions: [
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close"),
                            ),
                          ],
                        );
                      });
                }),
            SizedBox(
              height: 20,
            ),
            ListTile(
              // leading: Icon(Icons.policy),
              title: Text("Version 1.0.3"),
              // trailing: Icon(Icons.policy),
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Version 1.0.3 ~ Mr. Grey",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
