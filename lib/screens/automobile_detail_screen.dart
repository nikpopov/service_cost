import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/automobile.dart';
import '../models/period_cost_breakdown.dart';
import '../services/cost_calculation_service.dart';
import '../services/spare_part_provider.dart';
import '../services/service_record_provider.dart';
import '../services/currency_provider.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import '../widgets/spare_parts_tab.dart';
import '../widgets/service_records_tab.dart';
import '../widgets/period_breakdown_widget.dart';
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

  // Period analysis state
  PeriodType _selectedPeriodType = PeriodType.monthly;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load saved date preferences or use defaults
    _loadDatePreferences();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<SparePartProvider>()
          .loadSparePartsByAutomobile(widget.automobile.id);
      context
          .read<ServiceRecordProvider>()
          .loadServiceRecordsByAutomobile(widget.automobile.id);
    });
  }

  Future<void> _loadDatePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStartDateMillis = prefs.getInt('period_analysis_start_date');
    final savedEndDateMillis = prefs.getInt('period_analysis_end_date');
    final savedPeriodType = prefs.getString('period_analysis_period_type');

    setState(() {
      if (savedStartDateMillis != null && savedEndDateMillis != null) {
        // Use saved dates
        _startDate = DateTime.fromMillisecondsSinceEpoch(savedStartDateMillis);
        _endDate = DateTime.fromMillisecondsSinceEpoch(savedEndDateMillis);
      } else {
        // Default to last 6 months (calculate independently)
        final now = DateTime.now();
        _endDate = now;
        _startDate = DateTime(now.year, now.month - 6, now.day);
      }

      if (savedPeriodType != null) {
        try {
          _selectedPeriodType = PeriodType.values.firstWhere(
            (type) => type.name == savedPeriodType,
          );
        } catch (e) {
          // Keep default if parsing fails
        }
      }
    });
  }

  Future<void> _saveDatePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (_startDate != null) {
      await prefs.setInt('period_analysis_start_date', _startDate!.millisecondsSinceEpoch);
    }
    if (_endDate != null) {
      await prefs.setInt('period_analysis_end_date', _endDate!.millisecondsSinceEpoch);
    }
    await prefs.setString('period_analysis_period_type', _selectedPeriodType.name);
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
            Tab(text: 'Period Analysis', icon: Icon(Icons.bar_chart)),
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
          // Engine & Fluid Specifications Card
          if (_hasSpecifications(widget.automobile))
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Specifications',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 4,
                    children: [
                      if (widget.automobile.engineType != null)
                        _buildSpecItem(
                          Icons.settings,
                          'Engine',
                          widget.automobile.engineType!,
                        ),
                      if (widget.automobile.engineOilType != null)
                        _buildSpecItem(
                          Icons.opacity,
                          'Oil',
                          '${widget.automobile.engineOilType!}${widget.automobile.engineOilCapacity != null ? ' (${widget.automobile.engineOilCapacity}L)' : ''}',
                        ),
                      if (widget.automobile.coolantType != null)
                        _buildSpecItem(
                          Icons.ac_unit,
                          'Coolant',
                          '${widget.automobile.coolantType!}${widget.automobile.coolantVolume != null ? ' (${widget.automobile.coolantVolume}L)' : ''}',
                        ),
                      if (widget.automobile.transmissionType != null)
                        _buildSpecItem(
                          Icons.settings_suggest,
                          'Trans',
                          '${widget.automobile.transmissionType!}${widget.automobile.transmissionLiquidType != null ? ' (${widget.automobile.transmissionLiquidType!})' : ''}',
                        ),
                      if (widget.automobile.transferCaseType != null)
                        _buildSpecItem(
                          Icons.settings_input_component,
                          'T-Case',
                          '${widget.automobile.transferCaseType!}${widget.automobile.transferCaseOilType != null ? ' (${widget.automobile.transferCaseOilType!})' : ''}',
                        ),
                      if (widget.automobile.frontAxleType != null)
                        _buildSpecItem(
                          Icons.trip_origin,
                          'Front Axle',
                          '${widget.automobile.frontAxleType!}${widget.automobile.frontAxleOilType != null ? ' (${widget.automobile.frontAxleOilType!})' : ''}',
                        ),
                      if (widget.automobile.rearAxleType != null)
                        _buildSpecItem(
                          Icons.trip_origin,
                          'Rear Axle',
                          '${widget.automobile.rearAxleType!}${widget.automobile.rearAxleOilType != null ? ' (${widget.automobile.rearAxleOilType!})' : ''}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
          // Tabs Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SparePartsTab(automobileId: widget.automobile.id),
                ServiceRecordsTab(automobileId: widget.automobile.id),
                _buildPeriodAnalysisTab(),
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

  Widget _buildPeriodAnalysisTab() {
    final currencyProvider = context.watch<CurrencyProvider>();
    final calculationCurrency = currencyProvider.calculationCurrency;

    return Column(
      children: [
        // Period controls card
        Card(
          margin: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analysis Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Period type selector
                Row(
                  children: [
                    const Icon(Icons.calendar_view_month, size: 20),
                    const SizedBox(width: 8),
                    const Text('Period Type:'),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButton<PeriodType>(
                        value: _selectedPeriodType,
                        isExpanded: true,
                        items: PeriodType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.label),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedPeriodType = value;
                            });
                            _saveDatePreferences();
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Date range selectors
                Row(
                  children: [
                    Expanded(
                      child: _buildDateSelector(
                        'Start Date',
                        _startDate,
                        (date) {
                          setState(() => _startDate = date);
                          _saveDatePreferences();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDateSelector(
                        'End Date',
                        _endDate,
                        (date) {
                          setState(() => _endDate = date);
                          _saveDatePreferences();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Quick date range buttons
                Wrap(
                  spacing: 8,
                  children: [
                    _buildQuickRangeButton('Last Month', () {
                      final now = DateTime.now();
                      setState(() {
                        _endDate = now;
                        _startDate = DateTime(now.year, now.month - 1, now.day);
                      });
                      _saveDatePreferences();
                    }),
                    _buildQuickRangeButton('Last 3 Months', () {
                      final now = DateTime.now();
                      setState(() {
                        _endDate = now;
                        _startDate = DateTime(now.year, now.month - 3, now.day);
                      });
                      _saveDatePreferences();
                    }),
                    _buildQuickRangeButton('Last 6 Months', () {
                      final now = DateTime.now();
                      setState(() {
                        _endDate = now;
                        _startDate = DateTime(now.year, now.month - 6, now.day);
                      });
                      _saveDatePreferences();
                    }),
                    _buildQuickRangeButton('Last Year', () {
                      final now = DateTime.now();
                      setState(() {
                        _endDate = now;
                        _startDate = DateTime(now.year - 1, now.month, now.day);
                      });
                      _saveDatePreferences();
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Period breakdown content
        Expanded(
          child: _startDate != null && _endDate != null
              ? FutureBuilder<CostAnalysisByPeriod>(
                  future: _costService.calculateCostsByPeriod(
                    automobileId: widget.automobile.id,
                    periodType: _selectedPeriodType,
                    startDate: _startDate!,
                    endDate: _endDate!,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text('No data available'),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: PeriodBreakdownWidget(
                        analysis: snapshot.data!,
                        calculationCurrency: calculationCurrency,
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('Please select a date range'),
                ),
        ),
      ],
    );
  }

  Widget _buildDateSelector(String label, DateTime? date, Function(DateTime?) onChanged) {
    // For Start Date, use Jan 1 of current year or user's pre-set date (whichever is earlier)
    final DateTime defaultFirstDate = label == 'Start Date'
        ? DateTime(DateTime.now().year, 1, 1)
        : DateTime(2000);
    final DateTime firstDateToUse = label == 'Start Date' && _startDate != null
        ? (_startDate!.isBefore(defaultFirstDate) ? _startDate! : defaultFirstDate)
        : defaultFirstDate;

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now(),
          firstDate: firstDateToUse,
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          date != null
              ? '${date.year}-${_padZero(date.month)}-${_padZero(date.day)}'
              : 'Select date',
        ),
      ),
    );
  }

  Widget _buildQuickRangeButton(String label, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  String _padZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  bool _hasSpecifications(Automobile automobile) {
    return automobile.engineType != null ||
        automobile.engineOilType != null ||
        automobile.coolantType != null ||
        automobile.transmissionType != null ||
        automobile.transmissionLiquidType != null ||
        automobile.transferCaseType != null ||
        automobile.frontAxleType != null ||
        automobile.rearAxleType != null;
  }

  Widget _buildSpecItem(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[700]),
        const SizedBox(width: 4),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
