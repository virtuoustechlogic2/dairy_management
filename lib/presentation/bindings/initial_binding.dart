import 'package:get/get.dart';

import '../../data/datasources/hive_local_datasource.dart';
import '../../data/repositories/repositories_impl.dart';
import '../../presentation/controllers/app_controller.dart';
import '../../services/pdf_service.dart';
import '../../services/share_service.dart';

class InitialBinding extends Bindings {
  Future<void> initServices() async {
    final ds = HiveLocalDataSource();
    await ds.init();
    Get.put(ds, permanent: true);
  }

  @override
  void dependencies() {
    final ds = Get.find<HiveLocalDataSource>();
    Get.lazyPut(() => SupplierRepositoryImpl(ds));
    Get.lazyPut(() => MilkRepositoryImpl(ds));
    Get.lazyPut(() => RateRepositoryImpl(ds));
    Get.lazyPut(() => PdfService());
    Get.lazyPut(() => ShareService());
    Get.put(AppController(
      supplierRepo: Get.find<SupplierRepositoryImpl>(),
      milkRepo: Get.find<MilkRepositoryImpl>(),
      rateRepo: Get.find<RateRepositoryImpl>(),
      pdfService: Get.find<PdfService>(),
      shareService: Get.find<ShareService>(),
    ));
  }
}
