import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/app_exceptions.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../../services/pdf_service.dart';
import '../../services/share_service.dart';

class AppController extends GetxController {
  AppController({required this.supplierRepo, required this.milkRepo, required this.rateRepo, required this.pdfService, required this.shareService});

  final SupplierRepository supplierRepo;
  final MilkRepository milkRepo;
  final RateRepository rateRepo;
  final PdfService pdfService;
  final ShareService shareService;

  final suppliers = <Supplier>[].obs;
  final entries = <MilkEntry>[].obs;
  final rates = <FatRate>[].obs;
  final loading = false.obs;
  final error = RxnString();
  final _uuid = const Uuid();

  @override
  Future<void> onInit() async {
    super.onInit();
    await refreshAll();
  }

  Future<void> refreshAll() async {
    loading.value = true;
    try {
      suppliers.value = await supplierRepo.getSuppliers();
      rates.value = await rateRepo.getRates();
      entries.value = await milkRepo.getEntries(limit: 5000);
      error.value = null;
    } catch (e) {
      error.value = e.toString();
    } finally {
      loading.value = false;
    }
  }

  Future<void> saveSupplier({String? id, required String name, required String phone}) async {
    if (name.trim().isEmpty) throw AppException('Name required');
    await supplierRepo.upsertSupplier(Supplier(id: id ?? _uuid.v4(), name: name.trim(), phone: phone.trim()));
    await refreshAll();
  }

  Future<void> saveRate(MilkType type, double fat, double rate) async {
    if (fat <= 0 || rate <= 0) throw AppException('Fat/rate should be positive');
    await rateRepo.saveRate(FatRate(id: _uuid.v4(), milkType: type, fat: fat, rate: rate));
    await refreshAll();
  }

  Future<void> addEntry({required String supplierId, required DateTime date, required MilkType type, required double liters, required double fat}) async {
    if (supplierId.isEmpty || liters <= 0 || fat <= 0) throw AppException('Invalid input');
    if (date.isAfter(DateTime.now())) throw AppException('Future date not allowed');
    if (await milkRepo.existsForDay(supplierId, date, type)) throw AppException('Duplicate day entry for supplier & milk type');
    final rate = await rateRepo.findRate(type, fat);
    if (rate == null) throw AppException('Rate not configured for this fat range');
    await milkRepo.addEntry(MilkEntry(id: _uuid.v4(), supplierId: supplierId, date: date, milkType: type, liters: liters, fat: fat, rate: rate, amount: liters * rate));
    await refreshAll();
  }

  Map<String, dynamic> monthlySummary(DateTime month) {
    final monthEntries = entries.where((e) => e.date.year == month.year && e.date.month == month.month).toList();
    final totalLiters = monthEntries.fold<double>(0, (p, e) => p + e.liters);
    final totalAmount = monthEntries.fold<double>(0, (p, e) => p + e.amount);
    return {'entries': monthEntries, 'totalLiters': totalLiters, 'totalAmount': totalAmount};
  }

  Future<void> exportMonthly(DateTime month) async {
    final summary = monthlySummary(month);
    final map = {for (final s in suppliers) s.id: s};
    final file = await pdfService.generateMonthlySummary(title: 'Month: ${month.month}/${month.year}', entries: (summary['entries'] as List<MilkEntry>), supplierMap: map);
    await shareService.shareFile(file);
  }
}
