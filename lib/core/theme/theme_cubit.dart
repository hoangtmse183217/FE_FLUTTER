import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/theme/app_theme.dart';
import 'package:mumiappfood/core/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(AppThemeOptions.light));

  void setTheme(AppThemeOptions appTheme) {
    emit(ThemeState(appTheme));
  }

  /// Toggles the theme between light and dark mode.
  void toggleTheme() {
    // This is a simple toggle. If the current theme is dark, switch to light.
    // Otherwise, switch to dark.
    if (state.appTheme == AppThemeOptions.dark) {
      setTheme(AppThemeOptions.light);
    } else {
      setTheme(AppThemeOptions.dark);
    }
  }
}
