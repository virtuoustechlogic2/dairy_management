import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/app_controller.dart';
import '../widgets/app_scaffold.dart';
import 'supplier_form_screen.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) {
    final c = Get.find<AppController>();
    return AppScaffold(
      title: 'Suppliers',
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(decoration: const InputDecoration(labelText: 'Search'), onChanged: (v) => setState(() => query = v)),
        ),
        Expanded(
          child: Obx(() {
            final list = c.suppliers.where((e) => e.name.toLowerCase().contains(query.toLowerCase())).toList();
            if (list.isEmpty) return const Center(child: Text('No suppliers found'));
            return ListView.builder(itemCount: list.length, itemBuilder: (_, i) => ListTile(title: Text(list[i].name), subtitle: Text(list[i].phone), trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => Get.to(() => SupplierFormScreen(supplier: list[i])))));
          }),
        ),
      ]),
    );
  }
}
