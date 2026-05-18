import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../controllers/app_controller.dart';
import '../widgets/app_scaffold.dart';
import 'daily_entry_screen.dart';
import 'fat_rate_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';
import 'supplier_form_screen.dart';
import 'supplier_list_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AppController>();
    return AppScaffold(
      title: 'Dashboard',
      body: Obx(() {
        if (c.loading.value) return const Center(child: CircularProgressIndicator());
        if (c.error.value != null) return Center(child: Text(c.error.value!));
        return GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 700 ? 4 : 2,
          children: [
            _tile('Suppliers', () => Get.to(() => const SupplierListScreen())),
            _tile('Add Entry', () => Get.to(() => const DailyEntryScreen())),
            _tile('Fat Rates', () => Get.to(() => const FatRateScreen())),
            _tile('Reports', () => Get.to(() => const ReportsScreen())),
            _tile('Settings', () => Get.to(() => const SettingsScreen())),
          ],
        );
      }),
      fab: FloatingActionButton(onPressed: () => Get.to(() => const SupplierFormScreen()), child: const Icon(Icons.add)),
    );
  }

  Widget _tile(String text, VoidCallback onTap) => Card(child: InkWell(onTap: onTap, child: Center(child: Text(text))));
}
