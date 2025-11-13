import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/service_record.dart';
import '../services/service_record_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../screens/add_service_record_screen.dart';

class ServiceRecordsTab extends StatelessWidget {
  final String automobileId;

  const ServiceRecordsTab({super.key, required this.automobileId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ServiceRecordProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.serviceRecords.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.construction_outlined,
                    size: 64,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    'No service records yet',
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
            itemCount: provider.serviceRecords.length,
            itemBuilder: (context, index) {
              final record = provider.serviceRecords[index];
              return _buildServiceRecordCard(context, record);
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
                  AddServiceRecordScreen(automobileId: automobileId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildServiceRecordCard(BuildContext context, ServiceRecord record) {
    Color typeColor;
    IconData typeIcon;

    switch (record.type) {
      case ServiceType.maintenance:
        typeColor = AppConstants.maintenanceColor;
        typeIcon = Icons.build;
        break;
      case ServiceType.repair:
        typeColor = AppConstants.repairColor;
        typeIcon = Icons.construction;
        break;
      case ServiceType.inspection:
        typeColor = AppConstants.inspectionColor;
        typeIcon = Icons.checklist;
        break;
      case ServiceType.other:
        typeColor = AppConstants.otherColor;
        typeIcon = Icons.more_horiz;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    record.title,
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
                    color: typeColor,
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusSmall,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(typeIcon, size: 14, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        _getTypeLabel(record.type),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppConstants.fontSizeSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      Formatters.formatDate(record.serviceDate),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  Formatters.formatCurrency(record.cost),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ],
            ),
            if (record.mileage != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.speed, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Mileage: ${Formatters.formatNumber(record.mileage!)} km',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
            if (record.serviceProvider != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.business, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Provider: ${record.serviceProvider}',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
            if (record.description != null && record.description!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                record.description!,
                style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
              ),
            ],
            if (record.notes != null && record.notes!.isNotEmpty) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              Text(
                record.notes!,
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
    );
  }

  String _getTypeLabel(ServiceType type) {
    switch (type) {
      case ServiceType.maintenance:
        return 'Maintenance';
      case ServiceType.repair:
        return 'Repair';
      case ServiceType.inspection:
        return 'Inspection';
      case ServiceType.other:
        return 'Other';
    }
  }
}
