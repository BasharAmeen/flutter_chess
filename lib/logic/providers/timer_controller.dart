import 'package:flutter/foundation.dart';

class TimerController with ChangeNotifier {
  late int pOneMinutes;
  int pOneseconds = 0;
  int initialMinutes;
  int pounsValue = 0;
  bool shouildreset1 = false;
  bool shouildreset2 = false;

  TimerController({required this.initialMinutes}) {
    pOneMinutes = initialMinutes;
    pTwoMinutes = initialMinutes;
  }
  void minusPOneMinutes() {
    pOneMinutes--;

    if (pOneMinutes == 0) {
      pOneMinutes = 10;
    }
    notifyListeners();
  }

  void reAssignPOneSeconds(int value) {
    pOneseconds = value;
    notifyListeners();
  }

  late int pTwoMinutes;
  int pTwoseconds = 0;
  void minusPTwoMinutes() {
    pTwoMinutes--;
    if (pTwoMinutes == 0) {
      pTwoMinutes = 10;
    }
    notifyListeners();
  }

  void reAssignPTwoSeconds(int value) {
    pTwoseconds = value;
    notifyListeners();
  }

  void reset() {
    pOneMinutes = initialMinutes;
    pTwoMinutes = initialMinutes;
    pOneseconds = 0;
    pTwoseconds = 0;
    shouildreset1 = true;
    shouildreset2 = true;

    notifyListeners();
  }
}
