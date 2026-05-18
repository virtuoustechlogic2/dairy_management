import 'package:collection/collection.dart';

import '../../core/constants/app_constants.dart';
import '../../core/error/app_exceptions.dart';
import '../../core/utils/date_utils.dart';
import '../../domain/entities/entities.dart';
import '../../domain/repositories/repositories.dart';
import '../datasources/hive_local_datasource.dart';
import '../models/models.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final HiveLocalDataSource ds;
  SupplierRepositoryImpl(this.ds);
  @override
  Future<List<Supplier>> getSuppliers({String query = ''}) async {
    final data = ds.suppliers.values.map((e) => SupplierModel.fromMap(Map.from(e))).toList();
    if (query.isEmpty) return data;
    return data.where((e) => e.name.toLowerCase().contains(query.toLowerCase())).toList();
  }
  @override
  Future<void> upsertSupplier(Supplier supplier) async {
    final dup = ds.suppliers.values
        .map((e) => SupplierModel.fromMap(Map.from(e)))
        .any((e) => e.name.toLowerCase() == supplier.name.toLowerCase() && e.id != supplier.id);
    if (dup) throw DatabaseException('Duplicate supplier name.');
    await ds.suppliers.put(supplier.id, SupplierModel(id: supplier.id, name: supplier.name, phone: supplier.phone, isActive: supplier.isActive).toMap());
  }
}

class RateRepositoryImpl implements RateRepository {
  final HiveLocalDataSource ds;
  RateRepositoryImpl(this.ds);
  @override
  Future<double?> findRate(milkType, double fat) async {
    final rates = await getRates();
    return rates.where((e) => e.milkType == milkType).sortedBy<num>((e) => (e.fat - fat).abs()).firstOrNull?.rate;
  }
  @override
  Future<List<FatRate>> getRates() async => ds.rates.values.map((e) => FatRateModel.fromMap(Map.from(e))).toList();
  @override
  Future<void> saveRate(FatRate rate) async => ds.rates.put(rate.id, FatRateModel(id: rate.id, milkType: rate.milkType, fat: rate.fat, rate: rate.rate).toMap());
}

class MilkRepositoryImpl implements MilkRepository {
  final HiveLocalDataSource ds;
  MilkRepositoryImpl(this.ds);

  @override
  Future<void> addEntry(MilkEntry entry) async => ds.entries.put(entry.id, MilkEntryModel(
    id: entry.id, supplierId: entry.supplierId, date: entry.date, milkType: entry.milkType, liters: entry.liters, fat: entry.fat, rate: entry.rate, amount: entry.amount).toMap());

  @override
  Future<bool> existsForDay(String supplierId, DateTime date, milkType) async {
    final key = DateHelper.toYmd(date);
    return ds.entries.values.map((e) => MilkEntryModel.fromMap(Map.from(e))).any((e) => e.supplierId == supplierId && DateHelper.toYmd(e.date) == key && e.milkType == milkType);
  }

  @override
  Future<List<MilkEntry>> getEntries({DateTime? from, DateTime? to, String? supplierId, int limit = AppConstants.lazyPageSize, int offset = 0}) async {
    var list = ds.entries.values.map((e) => MilkEntryModel.fromMap(Map.from(e))).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    if (from != null) list = list.where((e) => !e.date.isBefore(from)).toList();
    if (to != null) list = list.where((e) => !e.date.isAfter(to)).toList();
    if (supplierId != null && supplierId.isNotEmpty) list = list.where((e) => e.supplierId == supplierId).toList();
    return list.skip(offset).take(limit).toList();
  }
}
