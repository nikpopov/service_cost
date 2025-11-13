import 'package:flutter/foundation.dart';
import '../models/automobile.dart';
import 'automobile_repository.dart';

class AutomobileProvider extends ChangeNotifier {
  final AutomobileRepository _repository = AutomobileRepository();
  List<Automobile> _automobiles = [];
  bool _isLoading = false;
  String? _error;

  List<Automobile> get automobiles => _automobiles;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAutomobiles() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _automobiles = await _repository.getAllAutomobiles();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAutomobile(Automobile automobile) async {
    try {
      await _repository.insertAutomobile(automobile);
      await loadAutomobiles();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateAutomobile(Automobile automobile) async {
    try {
      await _repository.updateAutomobile(automobile);
      await loadAutomobiles();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteAutomobile(String id) async {
    try {
      await _repository.deleteAutomobile(id);
      await loadAutomobiles();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Automobile? getAutomobileById(String id) {
    try {
      return _automobiles.firstWhere((auto) => auto.id == id);
    } catch (e) {
      return null;
    }
  }
}
