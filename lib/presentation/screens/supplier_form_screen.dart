import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/entities.dart';
import '../controllers/app_controller.dart';

class SupplierFormScreen extends StatefulWidget {
  const SupplierFormScreen({super.key, this.supplier});
  final Supplier? supplier;

  @override
  State<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends State<SupplierFormScreen> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController name;
  late final TextEditingController phone;

  @override
  void initState() {
    name = TextEditingController(text: widget.supplier?.name ?? '');
    phone = TextEditingController(text: widget.supplier?.phone ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<AppController>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.supplier == null ? 'Add Supplier' : 'Edit Supplier')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(children: [
            TextFormField(controller: name, validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
            const SizedBox(height: 12),
            TextFormField(controller: phone),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;
                  try {
                    await c.saveSupplier(id: widget.supplier?.id, name: name.text, phone: phone.text);
                    if (mounted) Get.back();
                  } catch (e) {
                    Get.snackbar('Error', e.toString());
                  }
                },
                child: const Text('Save')),
          ]),
        ),
      ),
    );
  }
}
