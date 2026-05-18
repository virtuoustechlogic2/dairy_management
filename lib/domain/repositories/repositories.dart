import '../entities/entities.dart';

abstract class SupplierRepository {
  Future<List<Supplier>> getSuppliers({String query = ''});
  Future<void> upsertSupplier(Supplier supplier);
}

abstract class MilkRepository {
  Future<void> addEntry(MilkEntry entry);
  Future<List<MilkEntry>> getEntries({DateTime? from, DateTime? to, String? supplierId, int limit = 50, int offset = 0});
  Future<bool> existsForDay(String supplierId, DateTime date, milkType);
}

abstract class RateRepository {
  Future<void> saveRate(FatRate rate);
  Future<List<FatRate>> getRates();
  Future<double?> findRate(milkType, double fat);
}
