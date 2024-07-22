import 'package:bloc/bloc.dart';
import 'package:chats/presentation/themes/themes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

// class ThemeCubit extends Cubit<ThemeState> {
//   ThemeCubit() : super(ThemeInitial());
// }

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(mode: ThemeMode.light, theme: lightMode));

  void toggleTheme() {
    if (state.mode == ThemeMode.light) {
      emit(ThemeState(mode: ThemeMode.dark, theme: darkMode));
    } else {
      emit(ThemeState(mode: ThemeMode.light, theme: lightMode));
    }
  }
}
