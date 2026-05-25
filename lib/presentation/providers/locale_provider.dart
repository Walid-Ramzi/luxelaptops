import 'package:flutter/material.dart';

enum AppLanguage { en, fr, ar }

extension AppLanguageX on AppLanguage {
  String get label => switch (this) {
        AppLanguage.en => 'English',
        AppLanguage.fr => 'Français',
        AppLanguage.ar => 'العربية',
      };

  Locale get locale => switch (this) {
        AppLanguage.en => const Locale('en'),
        AppLanguage.fr => const Locale('fr'),
        AppLanguage.ar => const Locale('ar'),
      };

  bool get isRtl => this == AppLanguage.ar;
}

class LocaleProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.en;

  AppLanguage get language => _language;
  Locale get locale => _language.locale;
  bool get isRtl => _language.isRtl;

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }
}
