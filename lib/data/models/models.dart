import '../../core/constants/app_constants.dart';
import '../../domain/entities/entities.dart';

class SupplierModel extends Supplier {
  SupplierModel({required super.id, required super.name, required super.phone, super.isActive});
  factory SupplierModel.fromMap(Map map) => SupplierModel(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        isActive: map['isActive'] ?? true,
      );
  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'phone': phone, 'isActive': isActive};
}

class MilkEntryModel extends MilkEntry {
  MilkEntryModel({
    required super.id,
    required super.supplierId,
    required super.date,
    required super.milkType,
    required super.liters,
    required super.fat,
    required super.rate,
    required super.amount,
  });
  factory MilkEntryModel.fromMap(Map map) => MilkEntryModel(
        id: map['id'],
        supplierId: map['supplierId'],
        date: DateTime.parse(map['date']),
        milkType: MilkType.values.firstWhere((e) => e.name == map['milkType']),
        liters: (map['liters'] as num).toDouble(),
        fat: (map['fat'] as num).toDouble(),
        rate: (map['rate'] as num).toDouble(),
        amount: (map['amount'] as num).toDouble(),
      );
  Map<String, dynamic> toMap() => {
        'id': id,
        'supplierId': supplierId,
        'date': date.toIso8601String(),
        'milkType': milkType.name,
        'liters': liters,
        'fat': fat,
        'rate': rate,
        'amount': amount,
      };
}

class FatRateModel extends FatRate {
  FatRateModel({required super.id, required super.milkType, required super.fat, required super.rate});
  factory FatRateModel.fromMap(Map map) => FatRateModel(
      id: map['id'],
      milkType: MilkType.values.firstWhere((e) => e.name == map['milkType']),
      fat: (map['fat'] as num).toDouble(),
      rate: (map['rate'] as num).toDouble());
  Map<String, dynamic> toMap() => {'id': id, 'milkType': milkType.name, 'fat': fat, 'rate': rate};
}
