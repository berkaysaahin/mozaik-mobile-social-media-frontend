import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mozaik/events/theme_event.dart';
import 'package:mozaik/states/theme_state.dart';
import 'package:mozaik/utils/app_themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _themeKey = 'app_theme';

  ThemeBloc()
      : super(ThemeState(
          themeMode: ThemeMode.light,
          lightTheme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
        )) {
    on<SetInitialThemeEvent>((event, emit) {
      emit(state.copyWith(themeMode: event.themeMode));
    });
    on<ToggleThemeEvent>((event, emit) async {
      final newMode =
          state.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

      await _saveTheme(newMode);

      emit(state.copyWith(themeMode: newMode));
    });

    _loadTheme().then((savedMode) {
      if (savedMode != null && savedMode != state.themeMode) {
        add(ToggleThemeEvent());
      }
    });
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.toString());
  }

  Future<ThemeMode?> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    if (themeString == null) return null;

    return themeString.contains('dark') ? ThemeMode.dark : ThemeMode.light;
  }
}
