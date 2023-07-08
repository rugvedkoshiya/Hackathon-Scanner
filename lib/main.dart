import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:qrscanner/constant/firebase_constant.dart';
import 'package:qrscanner/constant/string_constant.dart';
import 'package:qrscanner/repository/request.repository.dart';
import 'package:qrscanner/screen/home_screen.dart';
import 'package:qrscanner/screen/login_screen.dart';

import 'constant/app_constant.dart';
import 'gen/app_localizations.dart';
import 'utils/shared_preference.dart';

bool isLogin = false;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

BuildContext get getContext => navigatorKey.currentState!.context;

ValueNotifier<ThemeData> themeNotifier = ValueNotifier(
  CustomAppTheme.lightTheme,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesHelper.instance.loadSavedData();
  if (firebaseAuth.currentUser != null &&
      firebaseAuth.currentUser!.emailVerified) {
    isLogin = await setData();
  }
  themeNotifier = ValueNotifier(SharedPreferencesHelper.instance.getTheme);
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  Locale _locale = Locale(SharedPreferencesHelper.instance.getLocale ?? "en");

  Future<void> setLocale(Locale locale) async {
    await SharedPreferencesHelper.instance.setLcoale(locale.languageCode);
    _locale = locale;
    themeNotifier.notifyListeners();
  }

  Locale getLocale() {
    String? storedLocale = SharedPreferencesHelper.instance.getLocale;
    return storedLocale != null
        ? AppLocalizations.supportedLocales
            .firstWhere((locale) => locale.languageCode == storedLocale)
        : const Locale("en");
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) {
        return MaterialApp(
          title: StaticString.appName,
          theme: theme,
          debugShowCheckedModeBanner: false,
          locale: _locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('gu'), // Gujarati
          ],
          home: isLogin ? const HomeScreen() : const LoginScreen(),
        );
      },
    );
  }
}
