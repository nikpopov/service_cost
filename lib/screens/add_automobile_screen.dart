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

  // Engine and fluid specifications controllers
  final _engineTypeController = TextEditingController();
  final _engineOilTypeController = TextEditingController();
  final _engineOilCapacityController = TextEditingController();
  final _coolantTypeController = TextEditingController();
  final _coolantVolumeController = TextEditingController();

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
      _engineTypeController.text = widget.automobile!.engineType ?? '';
      _engineOilTypeController.text = widget.automobile!.engineOilType ?? '';
      _engineOilCapacityController.text =
          widget.automobile!.engineOilCapacity?.toString() ?? '';
      _coolantTypeController.text = widget.automobile!.coolantType ?? '';
      _coolantVolumeController.text =
          widget.automobile!.coolantVolume?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _licensePlateController.dispose();
    _vinController.dispose();
    _engineTypeController.dispose();
    _engineOilTypeController.dispose();
    _engineOilCapacityController.dispose();
    _coolantTypeController.dispose();
    _coolantVolumeController.dispose();
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
        engineType: _engineTypeController.text.trim().isEmpty
            ? null
            : _engineTypeController.text.trim(),
        engineOilType: _engineOilTypeController.text.trim().isEmpty
            ? null
            : _engineOilTypeController.text.trim(),
        engineOilCapacity: _engineOilCapacityController.text.trim().isEmpty
            ? null
            : double.tryParse(_engineOilCapacityController.text.trim()),
        coolantType: _coolantTypeController.text.trim().isEmpty
            ? null
            : _coolantTypeController.text.trim(),
        coolantVolume: _coolantVolumeController.text.trim().isEmpty
            ? null
            : double.tryParse(_coolantVolumeController.text.trim()),
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
            const Divider(),
            const SizedBox(height: AppConstants.paddingSmall),
            const Text(
              'Engine & Fluid Specifications (Optional)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _engineTypeController,
              decoration: const InputDecoration(
                labelText: 'Engine Type',
                hintText: 'e.g., 2.5L 4-Cylinder, V6 3.5L',
                prefixIcon: Icon(Icons.settings),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _engineOilTypeController,
              decoration: const InputDecoration(
                labelText: 'Engine Oil Type',
                hintText: 'e.g., 5W-30, 10W-40',
                prefixIcon: Icon(Icons.opacity),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _engineOilCapacityController,
              decoration: const InputDecoration(
                labelText: 'Engine Oil Capacity (Liters)',
                hintText: 'e.g., 4.5',
                prefixIcon: Icon(Icons.local_gas_station),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final capacity = double.tryParse(value.trim());
                  if (capacity == null || capacity <= 0) {
                    return 'Please enter a valid capacity';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _coolantTypeController,
              decoration: const InputDecoration(
                labelText: 'Coolant Type',
                hintText: 'e.g., Ethylene Glycol, Long Life',
                prefixIcon: Icon(Icons.ac_unit),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _coolantVolumeController,
              decoration: const InputDecoration(
                labelText: 'Coolant Volume (Liters)',
                hintText: 'e.g., 6.5',
                prefixIcon: Icon(Icons.water_drop),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value != null && value.trim().isNotEmpty) {
                  final volume = double.tryParse(value.trim());
                  if (volume == null || volume <= 0) {
                    return 'Please enter a valid volume';
                  }
                }
                return null;
              },
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
