import 'package:flutter/foundation.dart';

class HangingPiece with ChangeNotifier {
  List hangingPiece = [
    null,
    [
      null,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      null,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      null,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      null,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      null,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      null,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      null,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
    [
      null,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ]
  ];

  void setAllFalse() {
    hangingPiece = hangingPiece.map((e) {
      if (e == null) {
        return null;
      }
      return e.map((e2) {
        return e2 == null ? null : false;
      }).toList();
    }).toList();
    // notifyListeners();
  }

  swapPoints({required List pointOne, required List pointTwo}) {
    var temp = hangingPiece[pointOne[0]][pointOne[1]];
    hangingPiece[pointOne[0]][pointOne[1]] =
        hangingPiece[pointTwo[0]][pointTwo[1]];
    hangingPiece[pointTwo[0]][pointTwo[1]] = temp;
    // notifyListeners();
  }

  pointValueChanger({required List point, required bool value}) {
    hangingPiece[point[0]][point[1]] = value;
    // notifyListeners();
  }
}
