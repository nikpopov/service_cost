import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/service_record.dart';
import '../services/service_record_provider.dart';
import '../utils/constants.dart';

class AddServiceRecordScreen extends StatefulWidget {
  final String automobileId;
  final ServiceRecord? serviceRecord;

  const AddServiceRecordScreen({
    super.key,
    required this.automobileId,
    this.serviceRecord,
  });

  @override
  State<AddServiceRecordScreen> createState() => _AddServiceRecordScreenState();
}

class _AddServiceRecordScreenState extends State<AddServiceRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  final _mileageController = TextEditingController();
  final _serviceProviderController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  ServiceType _selectedType = ServiceType.maintenance;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.serviceRecord != null) {
      _titleController.text = widget.serviceRecord!.title;
      _selectedType = widget.serviceRecord!.type;
      _costController.text = widget.serviceRecord!.cost.toString();
      _mileageController.text = widget.serviceRecord!.mileage?.toString() ?? '';
      _serviceProviderController.text =
          widget.serviceRecord!.serviceProvider ?? '';
      _selectedDate = widget.serviceRecord!.serviceDate;
      _descriptionController.text = widget.serviceRecord!.description ?? '';
      _notesController.text = widget.serviceRecord!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    _mileageController.dispose();
    _serviceProviderController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveServiceRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final provider = context.read<ServiceRecordProvider>();
      final serviceRecord = ServiceRecord(
        id: widget.serviceRecord?.id ?? const Uuid().v4(),
        automobileId: widget.automobileId,
        title: _titleController.text.trim(),
        type: _selectedType,
        cost: double.parse(_costController.text.trim()),
        mileage: _mileageController.text.trim().isEmpty
            ? null
            : int.parse(_mileageController.text.trim()),
        serviceProvider: _serviceProviderController.text.trim().isEmpty
            ? null
            : _serviceProviderController.text.trim(),
        serviceDate: _selectedDate,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: widget.serviceRecord?.createdAt ?? DateTime.now(),
      );

      if (widget.serviceRecord == null) {
        await provider.addServiceRecord(serviceRecord);
      } else {
        await provider.updateServiceRecord(serviceRecord);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.serviceRecord == null
              ? 'Add Service Record'
              : 'Edit Service Record',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'e.g., Oil Change, Brake Service',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            DropdownButtonFormField<ServiceType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Service Type',
                prefixIcon: Icon(Icons.category),
              ),
              items: const [
                DropdownMenuItem(
                  value: ServiceType.maintenance,
                  child: Text('Maintenance'),
                ),
                DropdownMenuItem(
                  value: ServiceType.repair,
                  child: Text('Repair'),
                ),
                DropdownMenuItem(
                  value: ServiceType.inspection,
                  child: Text('Inspection'),
                ),
                DropdownMenuItem(
                  value: ServiceType.other,
                  child: Text('Other'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Cost',
                hintText: 'e.g., 150.00',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the cost';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Please enter a valid cost';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _mileageController,
              decoration: const InputDecoration(
                labelText: 'Mileage (Optional)',
                hintText: 'e.g., 50000',
                prefixIcon: Icon(Icons.speed),
                suffixText: 'km',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _serviceProviderController,
              decoration: const InputDecoration(
                labelText: 'Service Provider (Optional)',
                hintText: 'e.g., Quick Lube, Joe\'s Garage',
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Service Date'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              trailing: const Icon(Icons.edit),
              onTap: _selectDate,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'What was done',
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Additional information',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveServiceRecord,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingMedium,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      widget.serviceRecord == null
                          ? 'Add Service Record'
                          : 'Update Service Record',
                      style:
                          const TextStyle(fontSize: AppConstants.fontSizeLarge),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
