import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool soundOn = false;
  bool vibrationOn = false;

  Future<void> getUserSetting() async {
    soundOn = await getUserSoundSettingState();
    vibrationOn = await getUserVibrationSettingState();
    setState(() {});
  }

  Future<bool> saveUserSoundSettingState({required bool value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("userSoundSettingState", value);
  }

  Future<bool> saveUserVibrationSettingState({required bool value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool("userVibrationSettingState", value);
  }

  Future<bool> getUserSoundSettingState() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      soundOn = prefs.getBool("userSoundSettingState")!;
    } catch (e) {
      await saveUserSoundSettingState(value: false);
      soundOn = false;
    }
    return soundOn;
  }

  Future<bool> getUserVibrationSettingState() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      vibrationOn = prefs.getBool("userVibrationSettingState")!;
    } catch (e) {
      await saveUserVibrationSettingState(value: false);
      vibrationOn = false;
    }
    return vibrationOn;
  }

  @override
  void initState() {
    super.initState();
    getUserSetting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Settings"),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            const Row(
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
            const Divider(
              height: 15,
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.volume_up_rounded),
              title: const Text("Beep Sound"),
              horizontalTitleGap: 0,
              trailing: Switch(
                value: soundOn,
                onChanged: (value) async {
                  await saveUserSoundSettingState(value: value);
                  setState(() {
                    soundOn = value;
                  });
                },
                activeTrackColor: Colors.green.shade300,
                activeColor: Colors.green,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.vibration_rounded),
              title: const Text("Vibration"),
              horizontalTitleGap: 0,
              trailing: Switch(
                value: vibrationOn,
                onChanged: (value) async {
                  await saveUserVibrationSettingState(value: value);
                  setState(() {
                    vibrationOn = value;
                  });
                },
                activeTrackColor: Colors.green.shade300,
                activeColor: Colors.green,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
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
            const Divider(
              height: 15,
              thickness: 2,
            ),
            ListTile(
              leading: const Icon(Icons.policy_rounded),
              title: const Text("Privacy Policy"),
              horizontalTitleGap: 0,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Privacy Policy"),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "We respect the privacy of user and we do not sell or misused your data.",
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text("Version 1.0.4"),
              horizontalTitleGap: 0,
              onTap: () {
                Fluttertoast.showToast(
                  msg: "Version 1.0.4 ~ Mr. Grey",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
