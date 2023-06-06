import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrscanner/main.dart';

void showToast({required dynamic message}) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 3,
    backgroundColor: Theme.of(getContext).primaryColorLight,
    textColor: Theme.of(getContext).primaryColorDark,
    // fontSize: getSize(16),
  );
}
