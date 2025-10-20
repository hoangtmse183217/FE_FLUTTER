import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/theme/app_theme.dart';
import 'package:mumiappfood/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(AppThemeOptions.light));

  void setTheme(AppThemeOptions appTheme) {
    emit(ThemeState(appTheme));
  }
}
