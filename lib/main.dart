import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mumiappfood/core/constants/strings.dart';
import 'package:mumiappfood/core/locale/locale_cubit.dart';
import 'package:mumiappfood/core/locale/locale_state.dart';
import 'package:mumiappfood/core/theme/app_theme.dart';
import 'package:mumiappfood/core/theme/theme_cubit.dart';
import 'package:mumiappfood/core/theme/theme_state.dart';
import 'package:mumiappfood/features/favorites/state/favorites_cubit.dart';
import 'package:mumiappfood/features/home/state/home_cubit.dart';
import 'package:mumiappfood/routes/app_router.dart';
import 'package:mumiappfood/l10n/app_localizations.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Khởi tạo format ngày tháng tiếng Việt
  await initializeDateFormatting('vi_VN', null);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => FavoritesCubit()..fetchFavorites()),
        BlocProvider(create: (_) => HomeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: AppStrings.appName,
                theme: AppTheme.getTheme(themeState.appTheme),
                darkTheme: AppTheme.darkTheme,
                routerConfig: AppRouter.router,
                locale: localeState.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
              );
            },
          );
        },
      ),
    );
  }
}
