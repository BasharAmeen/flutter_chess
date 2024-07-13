import 'package:flutter/material.dart';

import '../models/piece.dart';

List<List<int>> whereCanMove(
    {required Piece piece, required List board, BuildContext? context}) {
  List<List<int>> listOfPositions = [];

  constCheck(List list) {
    for (var item in list) {
      if ((board[item[0]][item[1]] == true ||
          (piece.name != 'pawn'
              ? board[item[0]][item[1]].color != piece.color
              : item[1] == piece.xAxis
                  ? false
                  : board[item[0]][item[1]].color != piece.color))) {
        listOfPositions.add(item);
      }
    }
  }

  xAxisCheck() {
    var y = piece.yAxis;
    var x = piece.xAxis;
    for (int i = x + 1; i < 9; i++) {
      if (board[y][i] == true) {
        listOfPositions.add([y, i]);
      } else if (board[y][i].color != piece.color) {
        listOfPositions.add([y, i]);
        break;
      } else {
        break;
      }
    }

    for (int i = x - 1; i >= 1; i--) {
      if (board[y][i] == true) {
        listOfPositions.add([y, i]);
      } else if (board[y][i].color != piece.color) {
        listOfPositions.add([y, i]);
        break;
      } else {
        break;
      }
    }
  }

  yAxisCheck() {
    var y = piece.yAxis;
    var x = piece.xAxis;

    for (int i = y + 1; i < 9; i++) {
      if (board[i][x] == true) {
        listOfPositions.add([i, x]);
      } else if (board[i][x].color != piece.color) {
        listOfPositions.add([i, x]);
        break;
      } else {
        break;
      }
    }

    for (int i = y - 1; i >= 1; i--) {
      if (board[i][x] == true) {
        listOfPositions.add([i, x]);
      } else if (board[i][x].color != piece.color) {
        listOfPositions.add([i, x]);
        break;
      } else {
        break;
      }
    }
  }

  diagonallyCheck() {
    var y = piece.yAxis;
    var x = piece.xAxis;
    // Right --> Up

    for (int i = x + 1, j = y + 1; i <= 8 && j <= 8; i++, j++) {
      if (board[j][i] == true) {
        listOfPositions.add([j, i]);
      } else if (board[j][i].color != piece.color) {
        listOfPositions.add([j, i]);
        break;
      } else {
        break;
      }
    }
    // Right --> Down

    for (int i = x + 1, j = y - 1; i <= 8 && j >= 1; i++, j--) {
      if (board[j][i] == true) {
        listOfPositions.add([j, i]);
      } else if (board[j][i].color != piece.color) {
        listOfPositions.add([j, i]);
        break;
      } else {
        break;
      }
    }
    // Left --> Up

    for (int i = x - 1, j = y + 1; i >= 1 && j <= 8; i--, j++) {
      if (board[j][i] == true) {
        listOfPositions.add([j, i]);
      } else if (board[j][i].color != piece.color) {
        listOfPositions.add([j, i]);
        break;
      } else {
        break;
      }
    }
    // Left --> Down

    for (int i = x - 1, j = y - 1; i >= 1 && j >= 1; i--, j--) {
      if (board[j][i] == true) {
        listOfPositions.add([j, i]);
      } else if (board[j][i].color != piece.color) {
        listOfPositions.add([j, i]);
        break;
      } else {
        break;
      }
    }
  }

  piece.movements(board).forEach((key, value) {
    if (key == 'const') {
      constCheck(value);
    }
    if (key == 'xAxis') {
      xAxisCheck();
    }
    if (key == 'yAxis') {
      yAxisCheck();
    }
    if (key == 'diagonally') {
      diagonallyCheck();
    }
    if (key == 'verifiedPositions') {
      for (int i = 0; i < value.length; i++) {
        listOfPositions.add(value[i]);
      }
    }
  });
  return listOfPositions;
}
