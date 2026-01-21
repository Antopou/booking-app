import 'package:flutter/material.dart';
import 'package:booking_app/services/preferences_service.dart';

class LocalizationProvider extends ChangeNotifier {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ja', 'JP'),
  ];

  final PreferencesService _preferencesService = PreferencesService();
  late Locale _currentLocale;

  LocalizationProvider() {
    _initializeLocale();
  }

  Locale get currentLocale => _currentLocale;

  Future<void> _initializeLocale() async {
    final language = await _preferencesService.getLanguage();
    if (language.contains('Japanese')) {
      _currentLocale = const Locale('ja', 'JP');
    } else {
      _currentLocale = const Locale('en', 'US');
    }
    notifyListeners();
  }

  Future<void> setLocale(String language) async {
    if (language.contains('Japanese')) {
      _currentLocale = const Locale('ja', 'JP');
    } else {
      _currentLocale = const Locale('en', 'US');
    }
    await _preferencesService.setLanguage(language);
    notifyListeners();
  }

  static Locale localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    if (locale == null) {
      return supportedLocales.first;
    }

    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }

    return supportedLocales.first;
  }
}
