import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import 'piece.dart';

class Bishop extends Piece {
  final icon = FontAwesome5.chess_bishop;
  Bishop({required int xAxis, required int yAxis, required Color color})
      : super(name: 'bishop', xAxis: xAxis, yAxis: yAxis, color: color);

  @override
  Map movements(List board) {
    return {'diagonally': true};
  }

  Bishop copyWith({
    bool? isMoved,
  }) {
    var temp = Bishop(xAxis: xAxis, yAxis: yAxis, color: color);

    temp.isSelected = isSelected;
    return temp;
  }
}
