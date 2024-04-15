import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'day_night_theme_state.dart';

class DayNightThemeCubit extends Cubit<DayNightThemeState> {
  DayNightThemeCubit() : super(const DayNightThemeInitial()) {
    loadTheme();
  }

  void loadTheme() {
    SharedPreferences.getInstance().then((prefs) {
      final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      emit(DayNightThemeChanged(isDarkTheme: isDarkTheme));
    });
  }

  void toggleTheme() {
    SharedPreferences.getInstance().then((prefs) {
      final isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
      prefs.setBool('isDarkTheme', !isDarkTheme);
      emit(DayNightThemeChanged(isDarkTheme: !isDarkTheme));
    });
  }
}
