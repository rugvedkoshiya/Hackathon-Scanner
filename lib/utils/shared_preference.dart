import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/app_constant.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._();
  static SharedPreferencesHelper instance = SharedPreferencesHelper._();
  // Shared Preference Keys
  static const String _kUserInfo = 'user_info';
  static const String _kTheme = 'theme';
  static const String _kLocale = 'locale';

  // Variables...
  // AuthModel? _userInfo;
  bool isDarkMode =
      SchedulerBinding.instance.window.platformBrightness == Brightness.light;
  bool notification = false;

  late SharedPreferences _prefs;
  PackageInfo? packageInfo;

  // Load saved data...
  Future<void> loadSavedData() async {
    _prefs = await SharedPreferences.getInstance();
    // _getUserDetail();
    _getTheme();
    loadPackageInfo();
  }

  //!------------------------------------------------- Setter --------------------------------------------------//

  // Set UserInfo...
  // Future<void> setUserInfo(
  //   AuthModel? userInfo,
  // ) async {
  //   _userInfo = userInfo;
  //   //  _userLoginModel = userLoginModel;

  //   if (userInfo == null) {
  //     removeCacheData();
  //   } else {
  //     _prefs = await SharedPreferences.getInstance();
  //     _prefs.setString(_kUserInfo, authModelToJson(userInfo));
  //   }
  // }

  // Set ThemeData
  Future<void> setTheme({required bool isDarkModeVal}) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool(_kTheme, isDarkModeVal);
    // _prefs.remove(_kTheme);
    isDarkMode = isDarkModeVal;
  }

  // Set Locale
  Future<void> setLcoale(String locale) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(_kLocale, locale);
  }

//!------------------------------------------------- Getter --------------------------------------------------//

  // User detail...
  // AuthModel? get getUserInfo => _userInfo;

  // User detail...
  // AuthModel? _getUserDetail() {
  //   final String userInfo = _prefs.getString(_kUserInfo) ?? "";
  //   _userInfo = userInfo.isEmpty ? null : userInfoFromStoredJson(userInfo);
  //   return getUserInfo;
  // }

  // Get ThemeData
  ThemeData get getTheme => _getTheme();

  // Get ThemeData
  ThemeData _getTheme() {
    if (_prefs.getBool(_kTheme) != null) {
      isDarkMode = _prefs.getBool(_kTheme)!;
    } else {
      isDarkMode = SchedulerBinding.instance.window.platformBrightness ==
          Brightness.light;
    }
    return isDarkMode ? CustomAppTheme.darkTheme : CustomAppTheme.lightTheme;
  }

  // Locale detail
  String? get getLocale => _prefs.getString(_kLocale);

  // Load package information
  Future<void> loadPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }

//!----------------------------------------------- Remove Cache Data --------------------------------------------------//
  // Remove Cache Data (Use only when user wants to remove all store data on app)...
  Future<bool> removeCacheData() async {
    return _prefs.remove(_kUserInfo);
  }
}
