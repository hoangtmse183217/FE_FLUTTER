import 'package:equatable/equatable.dart';
import 'package:mumiappfood/core/theme/app_theme.dart';

class ThemeState extends Equatable {
  final AppThemeOptions appTheme;

  const ThemeState(this.appTheme);

  @override
  List<Object> get props => [appTheme];
}
