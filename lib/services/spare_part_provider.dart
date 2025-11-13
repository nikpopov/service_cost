import 'package:flutter/foundation.dart';
import '../models/spare_part.dart';
import 'spare_part_repository.dart';

class SparePartProvider extends ChangeNotifier {
  final SparePartRepository _repository = SparePartRepository();
  List<SparePart> _spareParts = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedAutomobileId;

  List<SparePart> get spareParts => _spareParts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedAutomobileId => _selectedAutomobileId;

  Future<void> loadSparePartsByAutomobile(String automobileId) async {
    _isLoading = true;
    _error = null;
    _selectedAutomobileId = automobileId;
    notifyListeners();

    try {
      _spareParts = await _repository.getSparePartsByAutomobile(automobileId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addSparePart(SparePart sparePart) async {
    try {
      await _repository.insertSparePart(sparePart);
      if (_selectedAutomobileId != null) {
        await loadSparePartsByAutomobile(_selectedAutomobileId!);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateSparePart(SparePart sparePart) async {
    try {
      await _repository.updateSparePart(sparePart);
      if (_selectedAutomobileId != null) {
        await loadSparePartsByAutomobile(_selectedAutomobileId!);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteSparePart(String id) async {
    try {
      await _repository.deleteSparePart(id);
      if (_selectedAutomobileId != null) {
        await loadSparePartsByAutomobile(_selectedAutomobileId!);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  double getTotalCost() {
    return _spareParts.fold(0, (sum, part) => sum + part.totalCost);
  }

  double getImportedPartsCost() {
    return _spareParts
        .where((part) => part.source == PartSource.imported)
        .fold(0, (sum, part) => sum + part.totalCost);
  }

  double getLocalPartsCost() {
    return _spareParts
        .where((part) => part.source == PartSource.local)
        .fold(0, (sum, part) => sum + part.totalCost);
  }
}
