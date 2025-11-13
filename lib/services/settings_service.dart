import 'package:shared_preferences/shared_preferences.dart';
import '../models/currency.dart';

class SettingsService {
  static const String _calculationCurrencyKey = 'calculation_currency';
  static final SettingsService _instance = SettingsService._internal();

  factory SettingsService() {
    return _instance;
  }

  SettingsService._internal();

  Future<Currency> getCalculationCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyCode = prefs.getString(_calculationCurrencyKey);
    return Currency.fromCode(currencyCode) ?? Currency.usd;
  }

  Future<void> setCalculationCurrency(Currency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_calculationCurrencyKey, currency.code);
  }
}
