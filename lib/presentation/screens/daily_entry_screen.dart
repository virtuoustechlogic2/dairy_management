import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../controllers/app_controller.dart';

class DailyEntryScreen extends StatefulWidget {
  const DailyEntryScreen({super.key});

  @override
  State<DailyEntryScreen> createState() => _DailyEntryScreenState();
}

class _DailyEntryScreenState extends State<DailyEntryScreen> {
  final formKey = GlobalKey<FormState>();
  String? supplierId;
  MilkType type = MilkType.cow;
  DateTime date = DateTime.now();
  final liters = TextEditingController();
  final fat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(children: [
            Obx(() => DropdownButtonFormField<String>(value: supplierId, hint: const Text('Supplier'), items: c.suppliers.map((e) => DropdownMenuItem(value: e.id, child: Text(e.name))).toList(), onChanged: (v) => setState(() => supplierId = v), validator: (v) => v == null ? 'Required' : null)),
            const SizedBox(height: 10),
            DropdownButtonFormField<MilkType>(value: type, items: MilkType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(), onChanged: (v) => setState(() => type = v!)),
            const SizedBox(height: 10),
            TextFormField(controller: liters, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Liters'), validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Invalid liters' : null),
            const SizedBox(height: 10),
            TextFormField(controller: fat, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Fat'), validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Invalid fat' : null),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                await c.addEntry(supplierId: supplierId!, date: date, type: type, liters: double.parse(liters.text), fat: double.parse(fat.text));
                Get.back();
              } catch (e) { Get.snackbar('Error', e.toString()); }
            }, child: const Text('Save Entry'))
          ]),
        ),
      ),
    );
  }
}
