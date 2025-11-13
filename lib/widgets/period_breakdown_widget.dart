import 'package:flutter/material.dart';
import '../models/period_cost_breakdown.dart';
import '../models/currency.dart';

class PeriodBreakdownWidget extends StatelessWidget {
  final CostAnalysisByPeriod analysis;
  final Currency calculationCurrency;

  const PeriodBreakdownWidget({
    super.key,
    required this.analysis,
    required this.calculationCurrency,
  });

  @override
  Widget build(BuildContext context) {
    if (analysis.periods.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No data available for the selected period',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryCard(context),
        const SizedBox(height: 16),
        _buildPeriodsList(context),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    final highestPeriod = analysis.highestCostPeriod;
    final lowestPeriod = analysis.lowestCostPeriod;
    final averageCost = analysis.averageCostPerPeriod;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${analysis.periodType.label} Analysis',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Average Cost',
                    calculationCurrency.format(averageCost),
                    Icons.trending_flat,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Highest Cost',
                    highestPeriod != null
                        ? calculationCurrency.format(highestPeriod.totalCost)
                        : calculationCurrency.format(0),
                    Icons.trending_up,
                    Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Lowest Cost',
                    lowestPeriod != null
                        ? calculationCurrency.format(lowestPeriod.totalCost)
                        : calculationCurrency.format(0),
                    Icons.trending_down,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    context,
                    'Total Periods',
                    '${analysis.periods.length}',
                    Icons.calendar_today,
                    Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodsList(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Period Breakdown',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: analysis.periods.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final period = analysis.periods[index];
              return _buildPeriodItem(context, period);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodItem(BuildContext context, PeriodCostBreakdown period) {
    final hasData = period.totalCost > 0;

    return Container(
      color: hasData ? null : Colors.grey.withOpacity(0.05),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: hasData ? Colors.blue : Colors.grey,
          child: Text(
            calculationCurrency.format(period.totalCost, compact: true),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          period.label,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: hasData ? Colors.black87 : Colors.grey,
          ),
        ),
        subtitle: Text(
          '${period.sparePartsCount} parts, ${period.servicesCount} services',
          style: TextStyle(
            fontSize: 12,
            color: hasData ? Colors.grey[600] : Colors.grey[400],
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                _buildCostRow(
                  'Spare Parts',
                  period.sparePartsCost,
                  period.sparePartsCount,
                  Icons.build,
                  Colors.orange,
                ),
                const SizedBox(height: 8),
                _buildCostRow(
                  'Services',
                  period.servicesCost,
                  period.servicesCount,
                  Icons.car_repair,
                  Colors.green,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Cost',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        calculationCurrency.format(period.totalCost),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostRow(
    String label,
    double cost,
    int count,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$count item${count != 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Text(
          calculationCurrency.format(cost),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
