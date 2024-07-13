// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../models/bishop.dart';
import '../models/king.dart';
import '../models/knight.dart';
import '../models/pawn.dart';
import '../models/piece.dart';
import '../models/queen.dart';
import '../models/rook.dart';

class Board with ChangeNotifier {
  List? indexOfLastPawnUsePower;
  List selctedPiece = [];
  List<List<dynamic>> board = [
    [],
    [
      [],
      Rook(xAxis: 1, yAxis: 1, color: Colors.white),
      Knight(xAxis: 2, yAxis: 1, color: Colors.white),
      Bishop(xAxis: 3, yAxis: 1, color: Colors.white),
      Queen(xAxis: 4, yAxis: 1, color: Colors.white),
      King(xAxis: 5, yAxis: 1, color: Colors.white),
      Bishop(xAxis: 6, yAxis: 1, color: Colors.white),
      Knight(xAxis: 7, yAxis: 1, color: Colors.white),
      Rook(xAxis: 8, yAxis: 1, color: Colors.white),
    ],
    [
      [],
      Pawn(xAxis: 1, yAxis: 2, color: Colors.white),
      Pawn(xAxis: 2, yAxis: 2, color: Colors.white),
      Pawn(xAxis: 3, yAxis: 2, color: Colors.white),
      Pawn(xAxis: 4, yAxis: 2, color: Colors.white),
      Pawn(xAxis: 5, yAxis: 2, color: Colors.white),
      Pawn(xAxis: 6, yAxis: 2, color: Colors.white),
      Pawn(xAxis: 7, yAxis: 2, color: Colors.white),
      Pawn(xAxis: 8, yAxis: 2, color: Colors.white),
    ],
    [[], true, true, true, true, true, true, true, true],
    [[], true, true, true, true, true, true, true, true],
    [[], true, true, true, true, true, true, true, true],
    [[], true, true, true, true, true, true, true, true],
    [
      [],
      Pawn(xAxis: 1, yAxis: 7, color: Colors.black),
      Pawn(xAxis: 2, yAxis: 7, color: Colors.black),
      Pawn(xAxis: 3, yAxis: 7, color: Colors.black),
      Pawn(xAxis: 4, yAxis: 7, color: Colors.black),
      Pawn(xAxis: 5, yAxis: 7, color: Colors.black),
      Pawn(xAxis: 6, yAxis: 7, color: Colors.black),
      Pawn(xAxis: 7, yAxis: 7, color: Colors.black),
      Pawn(xAxis: 8, yAxis: 7, color: Colors.black),
    ],
    [
      [],
      Rook(xAxis: 1, yAxis: 8, color: Colors.black),
      Knight(xAxis: 2, yAxis: 8, color: Colors.black),
      Bishop(xAxis: 3, yAxis: 8, color: Colors.black),
      Queen(xAxis: 4, yAxis: 8, color: Colors.black),
      King(xAxis: 5, yAxis: 8, color: Colors.black),
      Bishop(xAxis: 6, yAxis: 8, color: Colors.black),
      Knight(xAxis: 7, yAxis: 8, color: Colors.black),
      Rook(xAxis: 8, yAxis: 8, color: Colors.black),
    ],
  ];
  late King whiteKing = board[1][5];
  late King blackKing = board[8][5];
  bool? isPlayerOneWin;
  bool isWidgetDraged = false;
  void changeIsWidgetDraged(bool newValue) {
    isWidgetDraged = newValue;
    // notifyListeners();
  }

  isPlayerOneWinValueChanger(nVal) {
    isPlayerOneWin = nVal;
    // notifyListeners();
  }

  void changeBoardVale(List index, value) {
    board[index[0]][index[1]] = value;
    // notifyListeners();
  }

  void swapPoints({required List pointOne, required List pointTwo}) {
    Piece temp = board[pointOne[0]][pointOne[1]];
    board[pointOne[0]][pointOne[1]] = true;
    board[pointTwo[0]][pointTwo[1]] = temp;
    // notifyListeners();
  }

  int choosenPieceToReplacePawn = 1;
  reAssignChoosenPieceToReplacePawn(int value) {
    choosenPieceToReplacePawn = value;
    // notifyListeners();
  }

  void reset() {
    board = Board().board;
    isPlayerOneWin = null;
    whiteKing = board[1][5];
    blackKing = board[8][5];
    choosenPieceToReplacePawn = 1;
    // notifyListeners();
  }

  Board copyWith() {
    Board innerBoard = Board();
    innerBoard.indexOfLastPawnUsePower = indexOfLastPawnUsePower;
    innerBoard.blackKing = blackKing.copyWith();
    innerBoard.whiteKing = whiteKing.copyWith();
    innerBoard.choosenPieceToReplacePawn = choosenPieceToReplacePawn;
    innerBoard.isPlayerOneWin = isPlayerOneWin;
    innerBoard.selctedPiece = selctedPiece;
    innerBoard.board = copyBoard();
    return innerBoard;
  }

  void readCopy(Board newBoard) {
    indexOfLastPawnUsePower = newBoard.indexOfLastPawnUsePower;
    blackKing = newBoard.blackKing.copyWith();
    whiteKing = newBoard.whiteKing.copyWith();
    choosenPieceToReplacePawn = newBoard.choosenPieceToReplacePawn;
    isPlayerOneWin = newBoard.isPlayerOneWin;
    selctedPiece = newBoard.selctedPiece;
    board = newBoard.board;
  }

  List<List> copyBoard() {
    List<List> copeyedBoard = [[]];

    for (var i = 1; i < 9; i++) {
      copeyedBoard.add(List.from(board[i]));
      for (var jj = 1; jj < 9; jj++) {
        if (copeyedBoard[i][jj] is Piece) {
          copeyedBoard[i][jj] = copeyedBoard[i][jj].copyWith();
        }
      }
    }
    return copeyedBoard;
  }
}
