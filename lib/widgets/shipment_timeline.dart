import 'package:flutter/material.dart';
import '../models/spare_part.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';

class ShipmentTimeline extends StatelessWidget {
  final SparePart part;

  const ShipmentTimeline({super.key, required this.part});

  @override
  Widget build(BuildContext context) {
    if (part.source != PartSource.imported) {
      return const SizedBox.shrink();
    }

    final hasAnyDate = part.orderPlacedDate != null ||
        part.shipmentDate != null ||
        part.deliveryToWarehouseDate != null ||
        part.expectedDeliveryDate != null ||
        part.receivingDate != null;

    if (!hasAnyDate) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(top: AppConstants.paddingMedium),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  part.shippingMethod == ShippingMethod.sea
                      ? Icons.directions_boat
                      : Icons.flight,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Text(
                  'Shipment Timeline',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (part.shippingMethod != null) ...[
                  const SizedBox(width: AppConstants.paddingSmall),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingSmall,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall,
                      ),
                    ),
                    child: Text(
                      part.shippingMethod == ShippingMethod.sea
                          ? 'Sea Freight'
                          : 'Air Freight',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            if (part.orderPlacedDate != null)
              _buildTimelineItem(
                Icons.shopping_cart,
                'Order Placed',
                part.orderPlacedDate!,
                true,
              ),
            if (part.shipmentDate != null)
              _buildTimelineItem(
                Icons.local_shipping,
                'Shipped',
                part.shipmentDate!,
                part.orderPlacedDate != null,
              ),
            if (part.deliveryToWarehouseDate != null)
              _buildTimelineItem(
                Icons.warehouse,
                'Delivered to Warehouse',
                part.deliveryToWarehouseDate!,
                part.shipmentDate != null,
              ),
            if (part.receivingDate != null)
              _buildTimelineItem(
                Icons.check_circle,
                'Received',
                part.receivingDate!,
                part.deliveryToWarehouseDate != null,
              ),
            if (part.expectedDeliveryDate != null &&
                part.receivingDate == null)
              _buildTimelineItem(
                Icons.schedule,
                'Expected Delivery',
                part.expectedDeliveryDate!,
                true,
                isExpected: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(
    IconData icon,
    String title,
    DateTime date,
    bool showLine, {
    bool isExpected = false,
  }) {
    final now = DateTime.now();
    final isPast = date.isBefore(now);
    final color = isExpected
        ? AppConstants.textSecondaryColor
        : (isPast ? AppConstants.importedColor : AppConstants.primaryColor);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, size: 16, color: color),
            ),
            if (showLine)
              Container(
                width: 2,
                height: 24,
                color: color.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: AppConstants.paddingMedium),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  Formatters.formatDate(date),
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
                if (isExpected && !isPast)
                  Text(
                    '(${_getDaysUntil(date)})',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textSecondaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getDaysUntil(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference > 1) {
      return 'in $difference days';
    } else if (difference == -1) {
      return 'Yesterday';
    } else {
      return '${difference.abs()} days ago';
    }
  }
}
