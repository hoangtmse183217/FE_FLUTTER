import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mumiappfood/core/locale/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(Locale('vi')));

  void setLocale(Locale locale) {
    emit(LocaleState(locale));
  }
}
