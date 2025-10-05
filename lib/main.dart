import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // <-- 1. Import Bloc
import 'package:mumiappfood/core/constants/strings.dart';
import 'package:mumiappfood/core/theme/app_theme.dart';
import 'package:mumiappfood/features/home/state/favorites_cubit.dart'; // <-- 2. Import Cubit
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
    // 3. CUNG CẤP FAVORITESCUBIT Ở CẤP CAO NHẤT
    return BlocProvider(
      create: (context) => FavoritesCubit()..fetchFavorites(),
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
      ),
    );
  }
}