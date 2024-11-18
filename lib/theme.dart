import 'package:flutter/material.dart';

import 'main.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData currentTheme;

  themeInit() {
    Color colorSeed = Colors.teal;
    String? storedBrightness = userPrefsBox.get('theme');
    switch (storedBrightness) {
      case null:
        currentTheme = ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: colorSeed, // Change this to your desired seed color
            brightness: Brightness.dark,
          ),
        );
        userPrefsBox.put('theme', 'dark');
        break;
      case 'dark':
        currentTheme = ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: colorSeed, // Change this to your desired seed color
            brightness: Brightness.dark,
          ),
        );
        break;
      case 'light':
        currentTheme = ThemeData.light().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: colorSeed, // Change this to your desired seed color
            brightness: Brightness.light,
          ),
        );
        break;
      default:
    }
  }

  setTheme(ThemeData theme) {
    currentTheme = theme;
    notifyListeners();
  }
}
