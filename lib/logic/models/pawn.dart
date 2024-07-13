import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

import '../providers/board_provider.dart';

import 'piece.dart';

class Pawn extends Piece {
  List whereCanEat = [];
  bool isFirstMove = true;
  bool usedFeature = false;

  final icon = FontAwesome5.chess_pawn;
  Pawn({required int xAxis, required int yAxis, required Color color})
      : super(name: 'pawn', xAxis: xAxis, yAxis: yAxis, color: color);
  int get operation {
    if (color.toString() != 'Color(0xffffffff)') return -1;
    return 1;
  }

  @override
  Map movements(List board) {
    List verifiedPositions = [];

    whereCanEat.clear();

    if (xAxis + 1 < 9 &&
        board[yAxis][xAxis + 1] is Pawn &&
        board[yAxis][xAxis + 1].color.toString() != color.toString() &&
        scaffoldKey.currentContext!
                .read<Board>()
                .indexOfLastPawnUsePower
                .toString() ==
            [yAxis, xAxis + 1].toString()) {
      verifiedPositions.add([yAxis + operation, xAxis + 1]);
    }

    if (xAxis - 1 > 0 &&
        board[yAxis][xAxis - 1] is Pawn &&
        board[yAxis][xAxis - 1].color.toString() != color.toString() &&
        scaffoldKey.currentContext!
                .read<Board>()
                .indexOfLastPawnUsePower
                .toString() ==
            [yAxis, xAxis - 1].toString()) {
      verifiedPositions.add([yAxis + operation, xAxis - 1]);
    }

    if (positionChecker([xAxis + 1, yAxis + operation]) &&
        board[yAxis + operation][xAxis + 1] != true &&
        board[yAxis + operation][xAxis + 1].color != color) {
      whereCanEat.add([yAxis + operation, xAxis + 1]);
    }
    if (positionChecker([xAxis - 1, yAxis + operation]) &&
        board[yAxis + operation][xAxis - 1] != true &&
        board[yAxis + operation][xAxis - 1].color != color) {
      whereCanEat.add([yAxis + operation, xAxis - 1]);
    }

    if (isFirstMove && board[yAxis + operation][xAxis] == true) {
      whereCanEat.add([yAxis + operation, xAxis]);

      if (isFirstMove && board[yAxis + operation + operation][xAxis] == true) {
        whereCanEat.add([yAxis + operation + operation, xAxis]);
      }
    }
    if (!isFirstMove &&
        positionChecker([yAxis + operation, xAxis]) &&
        board[yAxis + operation][xAxis] == true) {
      whereCanEat.add([yAxis + operation, xAxis]);
    }
    return {'const': whereCanEat, 'verifiedPositions': verifiedPositions};
  }

  Pawn copyWith({
    bool? isMoved,
  }) {
    var temp = Pawn(xAxis: xAxis, yAxis: yAxis, color: color);

    temp.isSelected = isSelected;
    temp.isFirstMove = isFirstMove;
    temp.usedFeature = usedFeature;
    temp.isSelected = isSelected;

    return temp;
  }
}
