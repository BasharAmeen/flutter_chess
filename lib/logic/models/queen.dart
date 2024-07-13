import 'package:fluttericon/font_awesome5_icons.dart';

import 'piece.dart';
import 'package:flutter/material.dart';

class Queen extends Piece {
  final icon = FontAwesome5.chess_queen;
  Queen({required int xAxis, required int yAxis, required Color color})
      : super(name: 'queen', xAxis: xAxis, yAxis: yAxis, color: color);

  @override
  Map movements(List board) {
    return {'xAxis': true, 'yAxis': true, 'diagonally': true};
  }

  Queen copyWith({
    bool? isMoved,
  }) {
    var temp = Queen(xAxis: xAxis, yAxis: yAxis, color: color);

    temp.isSelected = isSelected;
    return temp;
  }
}
