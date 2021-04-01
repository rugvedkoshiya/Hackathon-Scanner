import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hacktata/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final firestore = FirebaseFirestore.instance;
final firestorage = FirebaseStorage.instance;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

String displayName = "";
String mobileNo = "";

class _ProfileState extends State<Profile> {
  String _oldPass = "";
  String _newPass = "";
  String _newPassConf = "";
  String emailID = "";

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formChangekey = GlobalKey<FormState>();

  File? _cameraImage;
  final imagePicker = ImagePicker();

  Future getImageFromCamera() async {
    final cameraImageSelected =
        await imagePicker.getImage(source: ImageSource.camera);
    if (cameraImageSelected != null) {
      setState(() {
        _cameraImage = File(cameraImageSelected.path);
      });
    } else {
      print("No camera image selected");
    }
    // setState(() {
    //   if (cameraImageSelected != null) {
    //     _cameraImage = File(cameraImageSelected.path);
    //   } else {
    //     print("No image selected");
    //   }
    //   // _cameraImage = File(cameraImageSelected.path);
    // });
  }

  Future getImageFromGallery() async {
    final galleryImageSelected =
        await imagePicker.getImage(source: ImageSource.gallery);
    if (galleryImageSelected != null) {
      setState(() {
        _cameraImage = File(galleryImageSelected.path);
      });
    } else {
      print("No gallery image selected");
    }
    // setState(() {
    //   if (galleryImageSelected != null) {
    //     _cameraImage = File(galleryImageSelected.path);
    //   } else {
    //     print("No image selected");
    //   }
    //   // _cameraImage = File(cameraImageSelected.path);
    // });
  }

  Future uploadFileFunc(BuildContext context, File uploadFile) async {
    try {
      // firebaseAuth.currentUser!.email!;
      // var userUid = firebaseAuth.currentUser!.uid;
      await firestorage.ref('profiles/$userUid.png').putFile(uploadFile);
      profileLink =
          await firestorage.ref('profiles/$userUid.png').getDownloadURL();
      setState(() {
        print("Profile Uploaded");
      });
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    }
  }

  // Future getImageFromGallery() async {
  //   var galleryImageSelected = await imagePicker.pickImage(source: ImageSource.gallery);
  //       // PickedFile galleryImageSelected = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   setState(() {
  //     _galleryImage = galleryImageSelected;
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
          child: Form(
            key: _formkey,
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
                            // image: Image(profileLink),
                            image: NetworkImage(profileLink),
                            // image: _imageFile == null
                            //   ? NetworkImage("https://rugvedkoshiya.github.io/assets/img/avatars/avatar.jpg")
                            //   : FileImage(File(_imageFile.path)),
                            // image: NetworkImage(
                            //     "https://rugvedkoshiya.github.io/assets/img/avatars/avatar.jpg"),
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
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Your Name";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      displayName = value!;
                    },
                    initialValue: '$displayName',
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      contentPadding: EdgeInsets.only(top: 15),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Enter your name"
                    ),
                    onChanged: (value) {
                      setState(() {
                        displayName = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_rounded),
                      contentPadding: EdgeInsets.only(top: 15),
                      // labelText: "Email",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: userEmail,
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Mobile No";
                      } else if (value.length > 10) {
                        return "Enter valid Mobile No";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      mobileNo = value!;
                    },
                    initialValue: '$mobileNo',
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      contentPadding: EdgeInsets.only(top: 15),
                      // labelText: "Mobile",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Enter Mobile Number",
                    ),
                    onChanged: (value) {
                      setState(() {
                        mobileNo = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                ListTile(
                  title: Text("Change Password"),
                  trailing: Icon(Icons.security),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Change Password"),
                            content: Form(
                              key: _formChangekey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 25),
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
                                      onSaved: (value) {
                                        _oldPass = value!;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 3),
                                        labelText: "Enter Old Password",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Enter Password",
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _oldPass = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 25),
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
                                      onSaved: (value) {
                                        _newPass = value!;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 3),
                                        labelText: "Enter New Password",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Enter Password",
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _newPass = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 15),
                                    child: TextFormField(
                                      validator: (value) {
                                        if (value != _newPass) {
                                          return "Password does not match";
                                        }
                                      },
                                      onSaved: (value) {
                                        _newPassConf = value!;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 3),
                                        labelText: "Conform New Password",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        hintText: "Enter Password",
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          _newPassConf = value;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
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
                                  if (_formChangekey.currentState!.validate()) {
                                    try {
                                      // print("Try working");
                                      User user = firebaseAuth.currentUser!;
                                      emailID =
                                          firebaseAuth.currentUser!.email!;
                                      AuthCredential credential =
                                          EmailAuthProvider.credential(
                                              email: emailID,
                                              password: _oldPass);
                                      await firebaseAuth.currentUser!
                                          .reauthenticateWithCredential(
                                              credential);
                                      await user.updatePassword(_newPass);
                                      Navigator.of(context).pop();
                                      Flushbar(
                                        message:
                                            "Password Changed Successfully !!",
                                        icon: Icon(
                                          Icons.check_circle_rounded,
                                          size: 28.0,
                                          color: Colors.green,
                                        ),
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'user-not-found') {
                                        // print('No user found for that email.');
                                        Flushbar(
                                          title: "User Not Found !",
                                          message:
                                              "Email is not registerd! Signup now",
                                          icon: Icon(
                                            Icons.error,
                                            size: 28.0,
                                            color: Colors.red,
                                          ),
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                      } else if (e.code == 'wrong-password') {
                                        // print('Wrong password provided for that user.');
                                        Flushbar(
                                          title: "Wrong Password !",
                                          message:
                                              "Forgot password for recovery",
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
                                    // print("tumse na ho payega");
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
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
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
                            "displayName": displayName,
                            "mobileNo": int.parse(mobileNo),
                          }, SetOptions(merge: true)).then((_) {
                            // print("SSuccess!");
                            Flushbar(
                              title: "Profile Updated",
                              message:
                                  "Profile has been Successfully Updated !!",
                              icon: Icon(
                                Icons.check_circle_rounded,
                                size: 28.0,
                                color: Colors.green,
                              ),
                              duration: Duration(seconds: 3),
                            )..show(context);
                          });
                        } else {
                          // print("tez ho rahe ho");
                        }
                        // print(mobileNo);
                        // print(displayName);
                      },
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
                  onPressed: () async {
                    try {
                      await getImageFromCamera();
                      await uploadFileFunc(context, _cameraImage!);
                      print("Camera Uploaded");
                      // Navigator.of(context).pop();
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                      Flushbar(
                        title: "Could Not Update Profile",
                        message: "Select Smaller Image",
                        icon: Icon(
                          Icons.error,
                          size: 28.0,
                          color: Colors.red,
                        ),
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                  },
                  label: Text("Camera"),
                ),
                // ignore: deprecated_member_use
                FlatButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () async {
                    try {
                      await getImageFromGallery();
                      await uploadFileFunc(context, _cameraImage!);
                      print("Gallery Uploaded");
                      print(Navigator.defaultRouteName);
                      print(Navigator.canPop(context));
                      // Navigator.of(context).pop();
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                  label: Text("Gallary"),
                )
              ],
            ),
          ],
        ));
  }
}
