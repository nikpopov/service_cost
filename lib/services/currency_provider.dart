import 'package:flutter/foundation.dart';
import '../models/currency.dart';
import 'settings_service.dart';

class CurrencyProvider extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  Currency _calculationCurrency = Currency.usd;
  bool _isLoading = false;

  Currency get calculationCurrency => _calculationCurrency;
  bool get isLoading => _isLoading;

  Future<void> loadCalculationCurrency() async {
    _isLoading = true;
    notifyListeners();

    try {
      _calculationCurrency = await _settingsService.getCalculationCurrency();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> setCalculationCurrency(Currency currency) async {
    try {
      await _settingsService.setCalculationCurrency(currency);
      _calculationCurrency = currency;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
