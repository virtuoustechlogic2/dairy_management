import '../../core/constants/app_constants.dart';

class Supplier {
  final String id;
  final String name;
  final String phone;
  final bool isActive;
  Supplier({required this.id, required this.name, required this.phone, this.isActive = true});
}

class MilkEntry {
  final String id;
  final String supplierId;
  final DateTime date;
  final MilkType milkType;
  final double liters;
  final double fat;
  final double rate;
  final double amount;
  MilkEntry({
    required this.id,
    required this.supplierId,
    required this.date,
    required this.milkType,
    required this.liters,
    required this.fat,
    required this.rate,
    required this.amount,
  });
}

class FatRate {
  final String id;
  final MilkType milkType;
  final double fat;
  final double rate;
  FatRate({required this.id, required this.milkType, required this.fat, required this.rate});
}
