import 'package:flutter/foundation.dart';

class RoleOrganizer with ChangeNotifier {
  int? playerNumber;

  bool isFirstPlayerRole = true;
  int numberOfMoves = 0;
  void numberOfMovesValueChanger(int value) {
    numberOfMoves = value;
    notifyListeners();
  }

  void plusNumberOfMoves() {
    numberOfMoves++;
    notifyListeners();
  }

  void changeRole() {
    isFirstPlayerRole = !isFirstPlayerRole;
    notifyListeners();
  }

  void reset() {
    isFirstPlayerRole = true;
    numberOfMoves = 0;
    playerNumber = null;

    notifyListeners();
  }
}
