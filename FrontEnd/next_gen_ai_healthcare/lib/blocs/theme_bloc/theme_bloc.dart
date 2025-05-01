import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:next_gen_ai_healthcare/theme/app_theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final LocalThemeData localThemeData;
  ThemeBloc(this.localThemeData) : super(ThemeDarkState(theme: AppThemes.darkTheme)) {
    
    on<ThemeToggleLightEvent>((event, emit) {
      localThemeData.storeTheme('light');
      emit(ThemeLightState(theme: AppThemes.lightTheme));
    });
    on<ThemeToggleDarkEvent>((event, emit) {
      localThemeData.storeTheme('dark');
      emit(ThemeDarkState(theme: AppThemes.darkTheme));
    });
    _loadThemeData();
  }
  Future<void> _loadThemeData() async {
    bool isLight = localThemeData.getTheme();
    add(isLight ? ThemeToggleLightEvent() : ThemeToggleDarkEvent());
  }

  bool get isDark => state==ThemeDarkState(theme: AppThemes.darkTheme);
}
