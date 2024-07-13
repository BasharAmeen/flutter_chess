import 'package:flutter/cupertino.dart';
import '../providers/positions_provider.dart';
import '../providers/role_organizer.dart';
import 'where_can_move.dart';
import 'package:provider/provider.dart';

import '../providers/board_provider.dart';
import 'positions_filter.dart';

bool winnerChecker(
  BuildContext context,
) {
  var copyedBoard = context.read<Board>().board;
  var pieceColor = context.read<RoleOrganizer>().isFirstPlayerRole
      ? context.read<Board>().whiteKing.color.toString()
      : context.read<Board>().blackKing.color.toString();
  for (int i = 1; i < 9; i++) {
    for (int j = 1; j < 9; j++) {
      if (copyedBoard[i][j] == true ||
          copyedBoard[i][j].color.toString() != pieceColor) {
        continue;
      } else {
        context.read<Positions>().reAssign(whereCanMove(
            piece: context.read<Board>().board[i][j],
            board: context.read<Board>().board));
        List v = positionsFilter(
            context: context, pieceColor: pieceColor, pieceIndex: [i, j]);
        if (v.isNotEmpty) {
          return false;
        }
      }
    }
  }
  context.read<Board>().isPlayerOneWinValueChanger(
      context.read<RoleOrganizer>().isFirstPlayerRole ? false : true);
  return true;
}
