import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:qrscanner/constant/firebase_constant.dart';
import 'package:qrscanner/constant/string_constant.dart';
import 'package:qrscanner/repository/request.repository.dart';
import 'package:qrscanner/screen/home_screen.dart';
import 'package:qrscanner/screen/login_screen.dart';

bool isLogin = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (firebaseAuth.currentUser != null &&
      firebaseAuth.currentUser!.emailVerified) {
    await setData();
    isLogin = true;
  }
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: StaticString.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: isLogin ? const HomeScreen() : const LoginScreen(),
    );
  }
}
