import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/theme/app_theme.dart';
import 'presentation/bindings/initial_binding.dart';
import 'presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitialBinding().initServices();
  runApp(const MilkCollectionApp());
}

class MilkCollectionApp extends StatelessWidget {
  const MilkCollectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Milk Collection Management',
      theme: AppTheme.light,
      initialBinding: InitialBinding(),
      home: const SplashScreen(),
    );
  }
}
