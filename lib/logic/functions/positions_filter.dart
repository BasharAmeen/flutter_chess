import 'package:flutter/material.dart';
import 'package:flutter_chess/main.dart';
import '../providers/positions_provider.dart';
import 'package:provider/provider.dart';

import '../providers/board_provider.dart';
import '../models/king.dart';
import 'where_can_move.dart';

List positionsFilter(
    {required BuildContext context,
    required String pieceColor,
    required List pieceIndex}) {
  List copyedBoard = [];

  context.read<Board>().board.forEach((element) {
    copyedBoard.add(List.from(element));
  });

  List allPossiblePositions = context.read<Positions>().positions;
  var myKingPosition = pieceColor == 'Color(0xffffffff)'
      ? context.read<Board>().whiteKing.position
      : context.read<Board>().blackKing.position;
  for (int i = 1; i < 9; i++) {
    if (allPossiblePositions.isEmpty) break;
    for (int j = 1; j < 9; j++) {
      if (copyedBoard[i][j] == true ||
          copyedBoard[i][j].color.toString() == pieceColor) {
        continue;
      } else {
        var temp3 = myKingPosition;
        int? rookP, rookP2;
        for (int p = 0; p < allPossiblePositions.length; p++) {
          bool replaceTheKing = true;

          if (copyedBoard[pieceIndex[0]][pieceIndex[1]] is King) {
            rookP =
                copyedBoard[pieceIndex[0]][pieceIndex[1]].canReplaceTheKing(1);
            rookP2 =
                copyedBoard[pieceIndex[0]][pieceIndex[1]].canReplaceTheKing(2);

            if (rookP == 1 && allPossiblePositions[p][1] == 1) {
              copyedBoard[pieceIndex[0]][3] = copyedBoard[myKingPosition[0]][5];
              copyedBoard[pieceIndex[0]][5] = true;

              copyedBoard[pieceIndex[0]][4] = copyedBoard[myKingPosition[0]][1];
              copyedBoard[myKingPosition[0]][1] = true;

              myKingPosition = [pieceIndex[0], 3];
            } else if (rookP2 == 2 && allPossiblePositions[p][1] == 8) {
              copyedBoard[pieceIndex[0]][7] = copyedBoard[myKingPosition[0]][5];

              copyedBoard[myKingPosition[0]][5] = true;
              copyedBoard[pieceIndex[0]][6] = copyedBoard[myKingPosition[0]][8];
              copyedBoard[myKingPosition[0]][8] = true;

              myKingPosition = [pieceIndex[0], 7];
            } else {
              myKingPosition = allPossiblePositions[p];
              replaceTheKing = false;
            }
          } else {
            replaceTheKing = false;
          }
          List<List<int>> targetP;
          var temp = copyedBoard[pieceIndex[0]][pieceIndex[1]];
          var temp2 = copyedBoard[allPossiblePositions[p][0]]
              [allPossiblePositions[p][1]];
          if (!replaceTheKing) {
            copyedBoard[pieceIndex[0]][pieceIndex[1]] = true;
            copyedBoard[allPossiblePositions[p][0]]
                [allPossiblePositions[p][1]] = temp;
          }
          if (copyedBoard[i][j] != true) {
            targetP =
                whereCanMove(piece: copyedBoard[i][j], board: copyedBoard);
          } else {
            if (replaceTheKing) {
              if (rookP == 1) {
                copyedBoard[pieceIndex[0]][5] = copyedBoard[pieceIndex[0]][3];
                copyedBoard[pieceIndex[0]][1] = copyedBoard[pieceIndex[0]][1];
              } else {
                copyedBoard[pieceIndex[0]][5] = copyedBoard[pieceIndex[0]][7];
                copyedBoard[pieceIndex[0]][8] = copyedBoard[pieceIndex[0]][8];
              }
            } else {
              copyedBoard[pieceIndex[0]][pieceIndex[1]] = temp;
              copyedBoard[allPossiblePositions[p][0]]
                  [allPossiblePositions[p][1]] = temp2;
            }
            continue;
          }
          if (targetP.isNotEmpty && targetP.containsList(myKingPosition)) {
            if (replaceTheKing) {
              if (rookP == 1) {
                copyedBoard[pieceIndex[0]][5] = copyedBoard[pieceIndex[0]][3];
                copyedBoard[pieceIndex[0]][1] = copyedBoard[pieceIndex[0]][1];
              } else {
                copyedBoard[pieceIndex[0]][5] = copyedBoard[pieceIndex[0]][7];
                copyedBoard[pieceIndex[0]][8] = copyedBoard[pieceIndex[0]][8];
              }
            } else {
              copyedBoard[pieceIndex[0]][pieceIndex[1]] = temp;
              copyedBoard[allPossiblePositions[p][0]]
                  [allPossiblePositions[p][1]] = temp2;
            }
            allPossiblePositions.removeAt(p);
            p--;
            continue;
          }

          if (replaceTheKing) {
            if (rookP2 == 2) {
              var temp = copyedBoard[pieceIndex[0]][6];
              copyedBoard[pieceIndex[0]][6] = copyedBoard[pieceIndex[0]][7];
              copyedBoard[pieceIndex[0]][7] = true;
              copyedBoard[pieceIndex[0]][8] = temp;
              targetP =
                  whereCanMove(piece: copyedBoard[i][j], board: copyedBoard);
              if (targetP.isNotEmpty &&
                  targetP.containsList([pieceIndex[0], 6])) {
                copyedBoard[pieceIndex[0]][5] = copyedBoard[pieceIndex[0]][6];
                allPossiblePositions.removeAt(p);
                p--;
                continue;
              }
            }
            if (rookP == 1) {
              var temp = copyedBoard[pieceIndex[0]][4];
              copyedBoard[pieceIndex[0]][4] = copyedBoard[pieceIndex[0]][3];
              copyedBoard[pieceIndex[0]][7] = true;
              copyedBoard[pieceIndex[0]][8] = temp;
              targetP =
                  whereCanMove(piece: copyedBoard[i][j], board: copyedBoard);
              if (targetP.isNotEmpty &&
                  targetP.containsList([pieceIndex[0], 4])) {
                copyedBoard[pieceIndex[0]][5] = copyedBoard[pieceIndex[0]][4];
                allPossiblePositions.removeAt(p);
                p--;
                continue;
              }
            }
          }
          if (replaceTheKing) {
            if (rookP == 1) {
              copyedBoard[pieceIndex[0]][5] = copyedBoard[pieceIndex[0]][3];
              copyedBoard[pieceIndex[0]][1] = copyedBoard[pieceIndex[0]][1];
            } else {
              copyedBoard[pieceIndex[0]][5] = copyedBoard[pieceIndex[0]][7];
              copyedBoard[pieceIndex[0]][8] = copyedBoard[pieceIndex[0]][8];
            }
          } else {
            copyedBoard[pieceIndex[0]][pieceIndex[1]] = temp;
            copyedBoard[allPossiblePositions[p][0]]
                [allPossiblePositions[p][1]] = temp2;
          }
          myKingPosition = temp3;
        }
      }
    }
  }
  context.read<Positions>().reAssign(allPossiblePositions);
  return allPossiblePositions;
}
