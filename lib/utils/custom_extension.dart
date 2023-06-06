const String emailRegx =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

extension StringExtension on String {
  // Validate Email
  // String? get validateEmail => trim().isEmpty
  //     ? AppLocalizations.of(getContext)
  //         .emptyEmail //AlertMessageString.emptyEmail
  //     : !RegExp(emailRegx).hasMatch(trim())
  //         ? AppLocalizations.of(getContext).validEmail
  //         : null;
}
