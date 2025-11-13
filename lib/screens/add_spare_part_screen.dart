import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/spare_part.dart';
import '../services/spare_part_provider.dart';
import '../utils/constants.dart';

class AddSparePartScreen extends StatefulWidget {
  final String automobileId;
  final SparePart? sparePart;

  const AddSparePartScreen({
    super.key,
    required this.automobileId,
    this.sparePart,
  });

  @override
  State<AddSparePartScreen> createState() => _AddSparePartScreenState();
}

class _AddSparePartScreenState extends State<AddSparePartScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _partNumberController = TextEditingController();
  final _priceController = TextEditingController();
  final _importCostController = TextEditingController();
  final _shippingCostController = TextEditingController();
  final _supplierController = TextEditingController();
  final _originCountryController = TextEditingController();
  final _notesController = TextEditingController();

  PartSource _selectedSource = PartSource.local;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.sparePart != null) {
      _nameController.text = widget.sparePart!.name;
      _partNumberController.text = widget.sparePart!.partNumber ?? '';
      _priceController.text = widget.sparePart!.price.toString();
      _selectedSource = widget.sparePart!.source;
      _importCostController.text = widget.sparePart!.importCost?.toString() ?? '';
      _shippingCostController.text =
          widget.sparePart!.shippingCost?.toString() ?? '';
      _supplierController.text = widget.sparePart!.supplier ?? '';
      _originCountryController.text = widget.sparePart!.originCountry ?? '';
      _selectedDate = widget.sparePart!.purchaseDate;
      _notesController.text = widget.sparePart!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _partNumberController.dispose();
    _priceController.dispose();
    _importCostController.dispose();
    _shippingCostController.dispose();
    _supplierController.dispose();
    _originCountryController.dispose();
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

  Future<void> _saveSparePart() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final provider = context.read<SparePartProvider>();
      final sparePart = SparePart(
        id: widget.sparePart?.id ?? const Uuid().v4(),
        automobileId: widget.automobileId,
        name: _nameController.text.trim(),
        partNumber: _partNumberController.text.trim().isEmpty
            ? null
            : _partNumberController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        source: _selectedSource,
        importCost: _importCostController.text.trim().isEmpty
            ? null
            : double.parse(_importCostController.text.trim()),
        shippingCost: _shippingCostController.text.trim().isEmpty
            ? null
            : double.parse(_shippingCostController.text.trim()),
        supplier: _supplierController.text.trim().isEmpty
            ? null
            : _supplierController.text.trim(),
        originCountry: _originCountryController.text.trim().isEmpty
            ? null
            : _originCountryController.text.trim(),
        purchaseDate: _selectedDate,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        createdAt: widget.sparePart?.createdAt ?? DateTime.now(),
      );

      if (widget.sparePart == null) {
        await provider.addSparePart(sparePart);
      } else {
        await provider.updateSparePart(sparePart);
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
          widget.sparePart == null ? 'Add Spare Part' : 'Edit Spare Part',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Part Name',
                hintText: 'e.g., Brake Pads, Oil Filter',
                prefixIcon: Icon(Icons.build),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the part name';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _partNumberController,
              decoration: const InputDecoration(
                labelText: 'Part Number (Optional)',
                hintText: 'e.g., BP-1234',
                prefixIcon: Icon(Icons.tag),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price',
                hintText: 'e.g., 99.99',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the price';
                }
                if (double.tryParse(value.trim()) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            DropdownButtonFormField<PartSource>(
              value: _selectedSource,
              decoration: const InputDecoration(
                labelText: 'Source',
                prefixIcon: Icon(Icons.source),
              ),
              items: const [
                DropdownMenuItem(
                  value: PartSource.local,
                  child: Text('Local'),
                ),
                DropdownMenuItem(
                  value: PartSource.imported,
                  child: Text('Imported'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedSource = value);
                }
              },
            ),
            if (_selectedSource == PartSource.imported) ...[
              const SizedBox(height: AppConstants.paddingMedium),
              TextFormField(
                controller: _importCostController,
                decoration: const InputDecoration(
                  labelText: 'Import Cost (Optional)',
                  hintText: 'e.g., 25.00',
                  prefixIcon: Icon(Icons.local_shipping),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              TextFormField(
                controller: _shippingCostController,
                decoration: const InputDecoration(
                  labelText: 'Shipping Cost (Optional)',
                  hintText: 'e.g., 15.00',
                  prefixIcon: Icon(Icons.flight_takeoff),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              TextFormField(
                controller: _originCountryController,
                decoration: const InputDecoration(
                  labelText: 'Origin Country (Optional)',
                  hintText: 'e.g., USA, Japan, Germany',
                  prefixIcon: Icon(Icons.flag),
                ),
              ),
            ],
            const SizedBox(height: AppConstants.paddingMedium),
            TextFormField(
              controller: _supplierController,
              decoration: const InputDecoration(
                labelText: 'Supplier (Optional)',
                hintText: 'e.g., AutoZone, NAPA',
                prefixIcon: Icon(Icons.store),
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: const Text('Purchase Date'),
              subtitle: Text(
                '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
              ),
              trailing: const Icon(Icons.edit),
              onTap: _selectDate,
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
              onPressed: _isLoading ? null : _saveSparePart,
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
                      widget.sparePart == null ? 'Add Part' : 'Update Part',
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
