import '../gen/app_localizations.dart';
import '../main.dart';

const String emailRegx =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

extension StringExtension on String {
  // Validate Email...
  String? get validateEmail => trim().isEmpty
      ? AppLocalizations.of(getContext).emptyEmail
      : !RegExp(emailRegx).hasMatch(trim())
          ? AppLocalizations.of(getContext).validEmail
          : null;

  // Validate Password...
  String? get validatePassword => trim().isEmpty
      ? AppLocalizations.of(getContext).emptyPassword
      : trim().length < 8
          ? AppLocalizations.of(getContext).validPassword
          : null;

  // Validate Password...
  String? validateConfrimPassword({String? confirmPasswordVal}) =>
      (trim().isEmpty)
          ? AppLocalizations.of(getContext).emptyConfirmPassword
          : trim().length < 8
              ? AppLocalizations.of(getContext).validPassword
              : confirmPasswordVal == null
                  ? null
                  : this != confirmPasswordVal
                      ? AppLocalizations.of(getContext).passwordDoNotMatch
                      : null;
}
