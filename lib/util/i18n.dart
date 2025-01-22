import 'package:intl/intl.dart';

String languageCode() {
  String locale = Intl.getCurrentLocale();
  return locale;
}

String i18n(String en, String cn) {
  return languageCode() == "en" ? en : cn;
}
