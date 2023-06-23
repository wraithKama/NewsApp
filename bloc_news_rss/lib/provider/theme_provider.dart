import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDarkTheme = false;

  chnageTheme() {
    isDarkTheme = !isDarkTheme;
    notifyListeners();
  }
}
