import 'package:qrscanner/utils/shared_preference.dart';

import '../constant/app_constant.dart';
import '../main.dart';

Future<void> changeTheme() async {
  await SharedPreferencesHelper.instance
      .setTheme(isDarkModeVal: !SharedPreferencesHelper.instance.isDarkMode);
  SharedPreferencesHelper.instance.isDarkMode
      ? themeNotifier.value = CustomAppTheme.darkTheme
      : themeNotifier.value = CustomAppTheme.lightTheme;

  themeNotifier.notifyListeners();
}
