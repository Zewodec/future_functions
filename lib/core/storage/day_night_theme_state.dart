part of 'day_night_theme_cubit.dart';

@immutable
sealed class DayNightThemeState {
  final bool isDarkTheme;

  const DayNightThemeState._({
    required this.isDarkTheme,
  });
}

final class DayNightThemeInitial extends DayNightThemeState {
  const DayNightThemeInitial() : super._(isDarkTheme: false);
}

final class DayNightThemeChanged extends DayNightThemeState {
  const DayNightThemeChanged({required bool isDarkTheme}) : super._(isDarkTheme: isDarkTheme);
}
