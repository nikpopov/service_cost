import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/automobile_provider.dart';
import '../services/cost_calculation_service.dart';
import '../utils/constants.dart';
import '../utils/formatters.dart';
import 'automobile_detail_screen.dart';
import 'add_automobile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CostCalculationService _costService = CostCalculationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AutomobileProvider>().loadAutomobiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
      ),
      body: Consumer<AutomobileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text('Error: ${provider.error}'),
                  const SizedBox(height: AppConstants.paddingMedium),
                  ElevatedButton(
                    onPressed: () => provider.loadAutomobiles(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (provider.automobiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car_outlined,
                    size: 80,
                    color: AppConstants.textSecondaryColor,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Text(
                    'No automobiles yet',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeXLarge,
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  Text(
                    'Add your first automobile to get started',
                    style: TextStyle(
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            itemCount: provider.automobiles.length,
            itemBuilder: (context, index) {
              final automobile = provider.automobiles[index];
              return FutureBuilder(
                future: _costService.calculateCostSummary(automobile.id),
                builder: (context, snapshot) {
                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: AppConstants.paddingMedium,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(
                        AppConstants.paddingMedium,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: AppConstants.primaryColor,
                        child: const Icon(Icons.directions_car,
                            color: Colors.white),
                      ),
                      title: Text(
                        automobile.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppConstants.fontSizeLarge,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: AppConstants.paddingSmall),
                          Text('License: ${automobile.licensePlate}'),
                          if (snapshot.hasData) ...[
                            const SizedBox(height: AppConstants.paddingSmall),
                            Text(
                              'Total Cost: ${Formatters.formatCurrency(snapshot.data!.totalCost)}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppConstants.primaryColor,
                                fontSize: AppConstants.fontSizeMedium,
                              ),
                            ),
                          ],
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AutomobileDetailScreen(automobile: automobile),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddAutomobileScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
