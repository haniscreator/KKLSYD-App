import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark }

class ThemeState {
  final ThemeData themeData;
  final AppTheme appTheme;

  ThemeState({required this.themeData, required this.appTheme});
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier() : super(_lightTheme) {
    _loadTheme();
  }

  // Shared text style for app bar
  static const _appBarTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static final _lightTheme = ThemeState(
    themeData: ThemeData.light().copyWith(
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.grey.shade100,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: _appBarTextStyle.copyWith(color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      textTheme: ThemeData.light().textTheme.apply(
            bodyColor: Colors.black,
            displayColor: Colors.black,
          ),
    ),
    appTheme: AppTheme.light,
  );

  static final _darkTheme = ThemeState(
    themeData: ThemeData.dark().copyWith(
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: _appBarTextStyle.copyWith(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      textTheme: ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
    ),
    appTheme: AppTheme.dark,
  );

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    final newTheme =
        state.appTheme == AppTheme.light ? _darkTheme : _lightTheme;
    state = newTheme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', newTheme.appTheme == AppTheme.dark);
  }

  /// Load saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    state = isDarkMode ? _darkTheme : _lightTheme;
  }
}

/// Riverpod provider
final themeProvider =
    StateNotifierProvider<ThemeNotifier, ThemeState>((ref) => ThemeNotifier());
