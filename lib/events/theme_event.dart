import 'package:flutter/material.dart';

abstract class ThemeEvent {}

class ToggleThemeEvent extends ThemeEvent {}

class SetInitialThemeEvent extends ThemeEvent {
  final ThemeMode themeMode;

  SetInitialThemeEvent(this.themeMode);
}
