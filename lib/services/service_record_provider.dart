import 'package:flutter/foundation.dart';
import '../models/service_record.dart';
import 'service_record_repository.dart';

class ServiceRecordProvider extends ChangeNotifier {
  final ServiceRecordRepository _repository = ServiceRecordRepository();
  List<ServiceRecord> _serviceRecords = [];
  bool _isLoading = false;
  String? _error;
  String? _selectedAutomobileId;

  List<ServiceRecord> get serviceRecords => _serviceRecords;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get selectedAutomobileId => _selectedAutomobileId;

  Future<void> loadServiceRecordsByAutomobile(String automobileId) async {
    _isLoading = true;
    _error = null;
    _selectedAutomobileId = automobileId;
    notifyListeners();

    try {
      _serviceRecords =
          await _repository.getServiceRecordsByAutomobile(automobileId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addServiceRecord(ServiceRecord serviceRecord) async {
    try {
      await _repository.insertServiceRecord(serviceRecord);
      if (_selectedAutomobileId != null) {
        await loadServiceRecordsByAutomobile(_selectedAutomobileId!);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateServiceRecord(ServiceRecord serviceRecord) async {
    try {
      await _repository.updateServiceRecord(serviceRecord);
      if (_selectedAutomobileId != null) {
        await loadServiceRecordsByAutomobile(_selectedAutomobileId!);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteServiceRecord(String id) async {
    try {
      await _repository.deleteServiceRecord(id);
      if (_selectedAutomobileId != null) {
        await loadServiceRecordsByAutomobile(_selectedAutomobileId!);
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  double getTotalCost() {
    return _serviceRecords.fold(0, (sum, record) => sum + record.cost);
  }

  Map<ServiceType, double> getCostByType() {
    final Map<ServiceType, double> costByType = {};
    for (final type in ServiceType.values) {
      costByType[type] = _serviceRecords
          .where((record) => record.type == type)
          .fold(0, (sum, record) => sum + record.cost);
    }
    return costByType;
  }
}
