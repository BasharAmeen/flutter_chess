import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

import '../providers/board_provider.dart';
import 'piece.dart';
import 'rook.dart';

class King extends Piece {
  bool isMoved = false;
  final icon = FontAwesome5.chess_king;

  King({required int xAxis, required int yAxis, required Color color})
      : super(name: 'king', xAxis: xAxis, yAxis: yAxis, color: color);

  int canReplaceTheKing(int testNumber) {
    if (!isMoved) {
      if (testNumber == 1 &&
          scaffoldKey.currentContext!.read<Board>().board[yAxis][1] is Rook &&
          !scaffoldKey.currentContext!.read<Board>().board[yAxis][1].isMoved) {
        for (int i = xAxis - 1; i > 1; i--) {
          if (!(scaffoldKey.currentContext!.read<Board>().board[yAxis][i] ==
              true)) {
            return 0;
          }
        }
        return 1;
      } else if (testNumber == 2 &&
          scaffoldKey.currentContext!.read<Board>().board[yAxis][8] is Rook &&
          !scaffoldKey.currentContext!.read<Board>().board[yAxis][8].isMoved) {
        for (int i = xAxis + 1; i < 8; i++) {
          if (!(scaffoldKey.currentContext!.read<Board>().board[yAxis][i] ==
              true)) {
            return 0;
          }
        }

        return 2;
      }
    }
    return 0;
  }

  @override
  Map movements(List board) {
    int rookP = canReplaceTheKing(1);
    int rookP2 = canReplaceTheKing(2);
    return {
      'const': [
        if (positionChecker([xAxis + 1, yAxis + 1])) [yAxis + 1, xAxis + 1],
        if (positionChecker([xAxis, yAxis + 1])) [yAxis + 1, xAxis],
        if (positionChecker([xAxis - 1, yAxis + 1])) [yAxis + 1, xAxis - 1],
        if (positionChecker([xAxis + 1, yAxis])) [yAxis, xAxis + 1],
        if (positionChecker([yAxis, xAxis - 1])) [yAxis, xAxis - 1],
        if (positionChecker([yAxis - 1, xAxis - 1])) [yAxis - 1, xAxis - 1],
        if (positionChecker([yAxis - 1, xAxis])) [yAxis - 1, xAxis],
        if (positionChecker([yAxis - 1, xAxis + 1])) [yAxis - 1, xAxis + 1],
      ],
      if (rookP != 0 || rookP2 != 0)
        'verifiedPositions': <List<int>>[
          if (rookP == 1) [yAxis, 1],
          if (rookP2 == 2) [yAxis, 8]
        ]
    };
  }

  King copyWith({
    bool? isMoved,
  }) {
    var temp = King(xAxis: xAxis, yAxis: yAxis, color: color);
    temp.isMoved = isMoved ?? false;
    temp.isSelected = isSelected;
    return temp;
  }
}
