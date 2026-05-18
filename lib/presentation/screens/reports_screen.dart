import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AppController>();
    final month = DateTime.now();
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Obx(() {
        final summary = c.monthlySummary(month);
        final entries = summary['entries'] as List;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Total liters: ${summary['totalLiters']}'),
            Text('Total amount: ${summary['totalAmount']}'),
            Text('Entries: ${entries.length}'),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: () async { try { await c.exportMonthly(month); } catch (e) { Get.snackbar('Error', e.toString()); } }, child: const Text('Export + Share PDF')),
          ],
        );
      }),
    );
  }
}
