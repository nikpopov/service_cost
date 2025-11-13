import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/automobile.dart';
import '../services/cost_calculation_service.dart';
import '../services/spare_part_provider.dart';
import '../services/service_record_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/spare_parts_tab.dart';
import '../widgets/service_records_tab.dart';
import 'add_automobile_screen.dart';

class AutomobileDetailScreen extends StatefulWidget {
  final Automobile automobile;

  const AutomobileDetailScreen({super.key, required this.automobile});

  @override
  State<AutomobileDetailScreen> createState() => _AutomobileDetailScreenState();
}

class _AutomobileDetailScreenState extends State<AutomobileDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CostCalculationService _costService = CostCalculationService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<SparePartProvider>()
          .loadSparePartsByAutomobile(widget.automobile.id);
      context
          .read<ServiceRecordProvider>()
          .loadServiceRecordsByAutomobile(widget.automobile.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.automobile.displayName),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddAutomobileScreen(automobile: widget.automobile),
                ),
              ).then((_) => setState(() {}));
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Spare Parts', icon: Icon(Icons.build)),
            Tab(text: 'Services', icon: Icon(Icons.construction)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Cost Summary Card
          FutureBuilder(
            future: _costService.calculateCostSummary(widget.automobile.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final summary = snapshot.data!;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                color: AppConstants.primaryColor.withOpacity(0.1),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCostItem(
                          'Total Cost',
                          summary.totalCost,
                          Icons.attach_money,
                          AppConstants.primaryColor,
                        ),
                        _buildCostItem(
                          'Parts',
                          summary.totalSparePartsCost,
                          Icons.build,
                          AppConstants.importedColor,
                        ),
                        _buildCostItem(
                          'Services',
                          summary.totalServicesCost,
                          Icons.construction,
                          AppConstants.maintenanceColor,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Imported: ${Formatters.formatCurrency(summary.totalImportedPartsCost)}',
                          style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
                        ),
                        const SizedBox(width: AppConstants.paddingMedium),
                        Text(
                          'Local: ${Formatters.formatCurrency(summary.totalLocalPartsCost)}',
                          style: const TextStyle(fontSize: AppConstants.fontSizeSmall),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          // Tabs Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SparePartsTab(automobileId: widget.automobile.id),
                ServiceRecordsTab(automobileId: widget.automobile.id),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCostItem(String label, double amount, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppConstants.paddingSmall),
        Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: AppConstants.textSecondaryColor,
          ),
        ),
        Text(
          Formatters.formatCurrency(amount),
          style: TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
