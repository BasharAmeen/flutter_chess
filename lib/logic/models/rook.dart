import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import 'piece.dart';

class Rook extends Piece {
  final icon = FontAwesome5.chess_rook;
  bool isMoved = false;

  Rook({required int xAxis, required int yAxis, required Color color})
      : super(name: 'rook', xAxis: xAxis, yAxis: yAxis, color: color);

  @override
  Map movements(List board) {
    return {
      'xAxis': true,
      'yAxis': true,
    };
  }

  Rook copyWith({
    bool? isMoved,
  }) {
    var temp = Rook(xAxis: xAxis, yAxis: yAxis, color: color);
    temp.isMoved = isMoved ?? false;
    temp.isSelected = isSelected;
    return temp;
  }
}
