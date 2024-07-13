import 'package:flutter/material.dart';

class Themes with ChangeNotifier {
  static const Color whitePiece = Colors.white;
  static const Color blackPiece = Colors.black;
  Color get timerBox =>
      isDark ? Colors.black12 : const Color.fromARGB(255, 194, 192, 202);
  Color get timerText => isDark ? Colors.white60 : Colors.black;

  ThemeData whiteTheme = ThemeData.light();
  ThemeData darkTheme = ThemeData.dark();
  bool isDark = false;
  //TODO
  void swithMode(bool value) {
    isDark = value;
    notifyListeners();
  }
}
