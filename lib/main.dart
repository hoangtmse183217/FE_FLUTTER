import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mumiappfood/core/constants/strings.dart';
import 'package:mumiappfood/core/theme/app_theme.dart';
import 'package:mumiappfood/routes/app_router.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}