part of 'theme_cubit.dart';

// sealed class ThemeState extends Equatable {
//   const ThemeState();

//   @override
//   List<Object> get props => [];
// }

// final class ThemeInitial extends ThemeState {}

// Define the states
enum ThemeMode { light, dark }

class ThemeState extends Equatable {
  final ThemeMode mode;
  final ThemeData theme;

  const ThemeState({required this.mode, required this.theme});

  @override
  List<Object> get props => [mode, theme];
}
