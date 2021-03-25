import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String oldPass = "";
  String newPass = "";
  String newPassConf = "";
  String chagnePassError = "";
  // File _image;
  // final imagePicker = imagePicker();

  // Future getImage() async {
  //   final image = await imagePicker.getImage(Source: ImageSource.camera);
  //   setState(() {
  //     _image = File(image.path);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text("Hackathon Profile"),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10),
                          ),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          // image: _imageFile == null
                          //   ? NetworkImage("https://rugvedkoshiya.github.io/assets/img/avatars/avatar.jpg")
                          //   : FileImage(File(_imageFile.path)),
                          image: NetworkImage(
                              "https://rugvedkoshiya.github.io/assets/img/avatars/avatar.jpg"),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          color: Colors.green,
                        ),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: ((builder) => selectProfile()),
                            );
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "Full Name",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Enter Your Name",
                  ),
                ),
              ),
              // buildProfileTextField("Email", "username@example.com", false),
              Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "Email",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "username@example.com",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 35),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3),
                    labelText: "Mobile",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Enter Mobile Number",
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              ListTile(
                // leading: Icon(Icons.security),
                title: Text("Change Password"),
                trailing: Icon(Icons.security),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Change Password"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelText: "Enter Old Password",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: "Enter Password",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      oldPass = value;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 25),
                                child: TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelText: "Enter New Password",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: "Enter Password",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      newPass = value;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 3),
                                    labelText: "Conform New Password",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintText: "Enter Password",
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      newPassConf = value;
                                    });
                                  },
                                ),
                              ),
                              Text(
                                "$chagnePassError",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 14),
                              )
                            ],
                          ),
                          actions: [
                            // ignore: deprecated_member_use
                            OutlineButton(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "CLOSE",
                                style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 2,
                                    color: Colors.black),
                              ),
                            ),
                            // ignore: deprecated_member_use
                            RaisedButton(
                              onPressed: () async {
                                // Logic for Changing Password
                                if (newPass != newPassConf) {
                                  chagnePassError = "Password are not Matching";
                                } else {
                                  try {
                                    print("Try working");
                                    User user =
                                        FirebaseAuth.instance.currentUser;
                                    AuthCredential credential =
                                        EmailAuthProvider.credential(
                                            email:
                                                firebaseAuth.currentUser.email,
                                            password: oldPass);
                                    await FirebaseAuth.instance.currentUser
                                        .reauthenticateWithCredential(
                                            credential);
                                    await user.updatePassword(newPass);
                                    Navigator.of(context).pop();
                                    Flushbar(
                                      // title: "Success",
                                      message:
                                          "Password Changed Successfully !!",
                                      icon: Icon(
                                        Icons.check_circle_rounded,
                                        size: 28.0,
                                        color: Colors.green,
                                      ),
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  } catch (e) {
                                    print(e);
                                  }
                                }
                              },
                              color: Colors.green,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "CHANGE",
                                style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ignore: deprecated_member_use
                  OutlineButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.black),
                    ),
                  ),
                  // ignore: deprecated_member_use
                  RaisedButton(
                    onPressed: () {},
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectProfile() {
    return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
              "Choose Profile Photo",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ignore: deprecated_member_use
                FlatButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    // camera
                    print("working...");
                  },
                  label: Text("Camera"),
                ),
                // ignore: deprecated_member_use
                FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    // gallery
                  },
                  label: Text("Gallary"),
                )
              ],
            ),
          ],
        ));
  }
}
