import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _languageKey = 'selected_language';
  static const String _currencyKey = 'selected_currency';

  /// Save language preference
  Future<bool> setLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_languageKey, language);
  }

  /// Get saved language preference
  Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? 'English (US)';
  }

  /// Save currency preference
  Future<bool> setCurrency(String currency) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(_currencyKey, currency);
  }

  /// Get saved currency preference
  Future<String> getCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currencyKey) ?? 'USD';
  }

  /// Save both language and currency
  Future<bool> savePreferences(String language, String currency) async {
    final prefs = await SharedPreferences.getInstance();
    final langSaved = await prefs.setString(_languageKey, language);
    final currSaved = await prefs.setString(_currencyKey, currency);
    return langSaved && currSaved;
  }
}
