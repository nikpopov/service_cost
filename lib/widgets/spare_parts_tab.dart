import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/spare_part.dart';
import '../services/spare_part_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../screens/add_spare_part_screen.dart';
import 'shipment_timeline.dart';

class SparePartsTab extends StatelessWidget {
  final String automobileId;

  const SparePartsTab({super.key, required this.automobileId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SparePartProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.spareParts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.build_outlined,
                    size: 64,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    'No spare parts yet',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: provider.spareParts.length,
            itemBuilder: (context, index) {
              final part = provider.spareParts[index];
              return _buildSparePartCard(context, part);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddSparePartScreen(automobileId: automobileId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSparePartCard(BuildContext context, SparePart part) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        part.name,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingSmall,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: part.source == PartSource.imported
                            ? AppConstants.importedColor
                            : AppConstants.localColor,
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusSmall,
                        ),
                      ),
                      child: Text(
                        part.source == PartSource.imported ? 'Imported' : 'Local',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeSmall,
                        ),
                      ),
                    ),
                  ],
                ),
                if (part.partNumber != null) ...[
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    'Part #: ${part.partNumber}',
                    style: TextStyle(
                      color: AppConstants.textSecondaryColor,
                      fontSize: AppConstants.fontSizeSmall,
                    ),
                  ),
                ],
                const SizedBox(height: AppConstants.paddingSmall),
                Row(
                  children: [
                    const Icon(Icons.attach_money, size: 16),
                    Text(
                      'Price: ${Formatters.formatCurrency(part.price)}',
                      style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
                    ),
                  ],
                ),
                if (part.source == PartSource.imported &&
                    (part.importCost != null || part.shippingCost != null || part.customsClearanceCost != null)) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.flight_takeoff, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'Import: ${Formatters.formatCurrency(part.importCost ?? 0)} | '
                          'Shipping: ${Formatters.formatCurrency(part.shippingCost ?? 0)} | '
                          'Customs: ${Formatters.formatCurrency(part.customsClearanceCost ?? 0)}',
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: AppConstants.paddingSmall),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          Formatters.formatDate(part.purchaseDate),
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeSmall,
                            color: AppConstants.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Total: ${Formatters.formatCurrency(part.totalCost)}',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
                if (part.supplier != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.store, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'Supplier: ${part.supplier}',
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
                if (part.notes != null && part.notes!.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    part.notes!,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ShipmentTimeline(part: part),
        ],
      ),
    );
  }
}
