import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/automobile.dart';
import '../services/automobile_provider.dart';
import '../utils/constants.dart';

class AddAutomobileScreen extends StatefulWidget {
  final Automobile? automobile;

  const AddAutomobileScreen({super.key, this.automobile});

  @override
  State<AddAutomobileScreen> createState() => _AddAutomobileScreenState();
}

class _AddAutomobileScreenState extends State<AddAutomobileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _licensePlateController = TextEditingController();
  final _vinController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.automobile != null) {
      _makeController.text = widget.automobile!.make;
      _modelController.text = widget.automobile!.model;
      _yearController.text = widget.automobile!.year.toString();
      _licensePlateController.text = widget.automobile!.licensePlate;
      _vinController.text = widget.automobile!.vin ?? '';
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _licensePlateController.dispose();
    _vinController.dispose();
    super.dispose();
  }

  Future<void> _saveAutomobile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final provider = context.read<AutomobileProvider>();
      final automobile = Automobile(
        id: widget.automobile?.id ?? const Uuid().v4(),
        make: _makeController.text.trim(),
        model: _modelController.text.trim(),
        year: int.parse(_yearController.text.trim()),
        licensePlate: _licensePlateController.text.trim(),
        vin: _vinController.text.trim().isEmpty
            ? null
            : _vinController.text.trim(),
        createdAt: widget.automobile?.createdAt ?? DateTime.now(),
      );

      if (widget.automobile == null) {
        await provider.addAutomobile(automobile);
      } else {
        await provider.updateAutomobile(automobile);
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
          widget.automobile == null ? 'Add Automobile' : 'Edit Automobile',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            TextFormField(
              controller: _makeController,
              decoration: const InputDecoration(
                labelText: 'Make',
                hintText: 'e.g., Toyota, Honda, Ford',
                prefixIcon: Icon(Icons.business),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the make';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _modelController,
              decoration: const InputDecoration(
                labelText: 'Model',
                hintText: 'e.g., Camry, Civic, F-150',
                prefixIcon: Icon(Icons.directions_car),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the model';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Year',
                hintText: 'e.g., 2020',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the year';
                }
                final year = int.tryParse(value.trim());
                if (year == null) {
                  return 'Please enter a valid year';
                }
                if (year < 1900 || year > DateTime.now().year + 1) {
                  return 'Please enter a valid year';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _licensePlateController,
              decoration: const InputDecoration(
                labelText: 'License Plate',
                hintText: 'e.g., ABC-1234',
                prefixIcon: Icon(Icons.confirmation_number),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the license plate';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _vinController,
              decoration: const InputDecoration(
                labelText: 'VIN (Optional)',
                hintText: 'Vehicle Identification Number',
                prefixIcon: Icon(Icons.tag),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveAutomobile,
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
                      widget.automobile == null ? 'Add Automobile' : 'Update',
                      style: const TextStyle(fontSize: AppConstants.fontSizeLarge),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
