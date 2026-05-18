import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/app_constants.dart';

class HiveLocalDataSource {
  late final Box suppliers;
  late final Box entries;
  late final Box rates;

  Future<void> init() async {
    await Hive.initFlutter();
    suppliers = await Hive.openBox(AppConstants.hiveSupplierBox);
    entries = await Hive.openBox(AppConstants.hiveEntryBox);
    rates = await Hive.openBox(AppConstants.hiveRateBox);
  }
}
