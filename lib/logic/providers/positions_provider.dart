import 'package:flutter/cupertino.dart';

class Positions with ChangeNotifier {
  List positions = [];
  reAssign(List value) {
    positions = value;
    // notifyListeners();
  }

  void reset() {
    positions.clear();
  }
}
