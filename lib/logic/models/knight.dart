import 'package:fluttericon/font_awesome5_icons.dart';

import 'piece.dart';
import 'package:flutter/material.dart';

class Knight extends Piece {
  final icon = FontAwesome5.chess_knight;
  Knight({required int xAxis, required int yAxis, required Color color})
      : super(name: 'knight', xAxis: xAxis, yAxis: yAxis, color: color);

  @override
  Map movements(List board) {
    return {
      'const': [
        if (positionChecker([yAxis + 2, xAxis + 1])) [yAxis + 2, xAxis + 1],
        if (positionChecker([yAxis + 2, xAxis - 1])) [yAxis + 2, xAxis - 1],
        if (positionChecker([yAxis - 2, xAxis + 1])) [yAxis - 2, xAxis + 1],
        if (positionChecker([yAxis - 2, xAxis - 1])) [yAxis - 2, xAxis - 1],
        if (positionChecker([yAxis + 1, xAxis + 2])) [yAxis + 1, xAxis + 2],
        if (positionChecker([yAxis + 1, xAxis - 2])) [yAxis + 1, xAxis - 2],
        if (positionChecker([yAxis - 1, xAxis + 2])) [yAxis - 1, xAxis + 2],
        if (positionChecker([yAxis - 1, xAxis - 2])) [yAxis - 1, xAxis - 2],
      ]
    };
  }

  Knight copyWith({
    bool? isMoved,
  }) {
    var temp = Knight(xAxis: xAxis, yAxis: yAxis, color: color);

    temp.isSelected = isSelected;
    return temp;
  }
}
