import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../controllers/app_controller.dart';

class FatRateScreen extends StatefulWidget {
  const FatRateScreen({super.key});

  @override
  State<FatRateScreen> createState() => _FatRateScreenState();
}

class _FatRateScreenState extends State<FatRateScreen> {
  MilkType type = MilkType.cow;
  final fat = TextEditingController();
  final rate = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Fat Rate Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          DropdownButton<MilkType>(value: type, items: MilkType.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(), onChanged: (v) => setState(() => type = v!)),
          TextField(controller: fat, decoration: const InputDecoration(labelText: 'Fat')),
          TextField(controller: rate, decoration: const InputDecoration(labelText: 'Rate')),
          ElevatedButton(onPressed: () async {
            try { await c.saveRate(type, double.parse(fat.text), double.parse(rate.text)); }
            catch (e) { Get.snackbar('Error', e.toString()); }
          }, child: const Text('Save')),
          Expanded(child: Obx(() => ListView(children: c.rates.map((e) => ListTile(title: Text('${e.milkType.name} Fat ${e.fat}'), subtitle: Text('Rate ${e.rate}'))).toList())))
        ]),
      ),
    );
  }
}
