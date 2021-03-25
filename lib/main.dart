import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacktata/screens/login.dart';
import 'screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hacktata/screens/auth_service.dart';

// void main() {
//   runApp(MyApp());
// }
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


void main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}


class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Login(),
      // home: AuthCheck(),
      
    );
  }
}





// class AuthCheck extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<FirebaseUser>(
//             future: FirebaseAuth.instance.currentUser(),
//             builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot){
//                        if (snapshot.hasData){
//                            FirebaseUser user = snapshot.data; // this is your user instance
//                            /// is because there is user already logged
//                            return MainScreen();
//                         }
//                          /// other way there is no user logged.
//                          return LoginScreen();
//              }
//           );
//   }
// }