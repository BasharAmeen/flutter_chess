// ignore_for_file: use_build_context_synchronously

// import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../logic/models/king.dart';
import '../../../logic/models/rook.dart';
import '../../../logic/providers/board_provider.dart';
import '../../../logic/providers/hanging_piece_provider.dart';
import '../../../logic/models/pawn.dart';
import '../../../logic/models/piece.dart';
import '../../../logic/providers/online_game_controller.dart';

import '../../../logic/providers/role_organizer.dart';
import '../../../logic/functions/where_can_move.dart';
import '../../../logic/functions/winner_checker.dart';

import '../../../main.dart';
import 'show_piece_choices.dart';
import 'win_screen.dart';

class DragTargetPiece extends StatelessWidget {
  final List pieceIndex;
  const DragTargetPiece({Key? key, required this.pieceIndex}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: HitTestBehavior.translucent,
      onAccept: (oldPosition) async {
        onAccept(oldPosition!, pieceIndex, false);
        // if (isEat) {
        //   await eatAudio.play(UrlSource(
        //       'https://assets.mixkit.co/sfx/download/mixkit-game-quick-warning-notification-268.wav'));
        // }
      },
      builder: (_, __, ___) {
        return const SizedBox(
          width: 100,
          height: 100,
        );
      },
    );
  }
}

void pawnFun(BuildContext context, bool isEat, List<dynamic> oldPosition,
    {required List pieceIndex}) async {
  if (pieceIndex[0] == 8 || pieceIndex[0] == 1) {
    await showPieceChoices(context, pieceIndex);
    return;
  }
  // Checking pawn feature
  else if (!isEat &&
      (pieceIndex[1] + 1 == oldPosition[1] ||
          pieceIndex[1] - 1 == oldPosition[1])) {
    context.read<Board>().changeBoardVale([
      pieceIndex[0] -
          context.read<Board>().board[pieceIndex[0]][pieceIndex[1]].operation,
      pieceIndex[1]
    ], true);
  }

  if (context.read<Board>().board[pieceIndex[0]][pieceIndex[1]].isFirstMove) {
    if (pieceIndex[0] - 2 == oldPosition[0] ||
        pieceIndex[0] + 2 == oldPosition[0]) {
      context.read<Board>().indexOfLastPawnUsePower = pieceIndex;
      context.read<Board>().board[pieceIndex[0]][pieceIndex[1]].usedFeature =
          true;
    }
    context.read<Board>().board[pieceIndex[0]][pieceIndex[1]].isFirstMove =
        false;
  } else {
    context.read<Board>().board[pieceIndex[0]][pieceIndex[1]].usedFeature =
        false;
  }
}

Future<void> onAccept(Object oldPosition, List pieceIndex, bool isRead) async {
  var context = scaffoldKey.currentContext!;

  context.read<Board>().indexOfLastPawnUsePower = null;
  bool isEat =
      context.read<Board>().board[pieceIndex[0]][pieceIndex[1]] is Piece;
  //TODO
  // if (!isRead) {
  //   context.read<HangingPiece>().setAllFalse();
  // }
  // Checking Castling
  if (isEat &&
      context
              .read<Board>()
              .board[(oldPosition as List)[0]][oldPosition[1]]
              .color
              .toString() ==
          context
              .read<Board>()
              .board[pieceIndex[0]][pieceIndex[1]]
              .color
              .toString()) {
    if (pieceIndex[1] == 1) {
      context.read<Board>().swapPoints(
          pointOne: [...oldPosition], pointTwo: [oldPosition[0], 3]);
      context
          .read<Board>()
          .swapPoints(pointOne: [...pieceIndex], pointTwo: [oldPosition[0], 4]);

      context.read<Board>().board[pieceIndex[0]][3].xAxis = 3;
      context.read<Board>().board[pieceIndex[0]][4].xAxis = 4;
    } else {
      context.read<Board>().swapPoints(
          pointOne: [...oldPosition], pointTwo: [oldPosition[0], 7]);
      context
          .read<Board>()
          .swapPoints(pointOne: [...pieceIndex], pointTwo: [oldPosition[0], 6]);
      context.read<Board>().board[pieceIndex[0]][6].xAxis = 6;
      context.read<Board>().board[pieceIndex[0]][7].xAxis = 7;
    }
  } else {
    context
        .read<Board>()
        .swapPoints(pointOne: oldPosition as List, pointTwo: pieceIndex);

    context.read<Board>().board[pieceIndex[0]][pieceIndex[1]].xAxis =
        pieceIndex[1];
    context.read<Board>().board[pieceIndex[0]][pieceIndex[1]].yAxis =
        pieceIndex[0];
  }

  if (context.read<Board>().board[pieceIndex[0]][pieceIndex[1]] is Pawn) {
    pawnFun(context, isEat, oldPosition, pieceIndex: pieceIndex);
  } else if (context.read<Board>().board[pieceIndex[0]][pieceIndex[1]]
          is Rook ||
      context.read<Board>().board[pieceIndex[0]][pieceIndex[1]] is King) {
    context.read<Board>().board[pieceIndex[0]][pieceIndex[1]].isMoved = true;
  }
  context.read<RoleOrganizer>().changeRole();

  // Checkig if there is check
  List king = context.read<RoleOrganizer>().isFirstPlayerRole
      ? context.read<Board>().whiteKing.position
      : context.read<Board>().blackKing.position;

  if (context.read<Board>().board[pieceIndex[0]][pieceIndex[1]] != true) {
    if (whereCanMove(
            piece: context.read<Board>().board[pieceIndex[0]][pieceIndex[1]],
            board: scaffoldKey.currentContext!.read<Board>().board)
        .any((element) => element[0] == king[0] && element[1] == king[1])) {
      //TODO
      // scaffoldKey.currentContext!
      //     .read<HangingPiece>()
      //     .pointValueChanger(point: [king[0], king[1]], value: true);
      if (winnerChecker(scaffoldKey.currentContext!)) {
        await winDialog(
            context: scaffoldKey.currentContext!,
            oldPosition: oldPosition,
            pieceIndex: pieceIndex);
        return;
      }
    }
  } else {
    if (whereCanMove(
            piece: context.read<Board>().board[pieceIndex[0]]
                [pieceIndex[1] == 1 ? 3 : 7],
            board: scaffoldKey.currentContext!.read<Board>().board)
        .any((element) => element[0] == king[0] && element[1] == king[1])) {
      //TODO
      // scaffoldKey.currentContext!
      //     .read<HangingPiece>()
      //     .pointValueChanger(point: [king[0], king[1]], value: true);
      if (winnerChecker(scaffoldKey.currentContext!)) {
        await winDialog(
            context: scaffoldKey.currentContext!,
            oldPosition: oldPosition,
            pieceIndex: pieceIndex);
        return;
      }
    }
    if (whereCanMove(
            piece: scaffoldKey.currentContext!
                .read<Board>()
                .board[pieceIndex[0]][pieceIndex[1] == 1 ? 4 : 6],
            board: scaffoldKey.currentContext!.read<Board>().board)
        .any((element) => element[0] == king[0] && element[1] == king[1])) {
      //TODO
      // scaffoldKey.currentContext!
      //     .read<HangingPiece>()
      //     .pointValueChanger(point: [king[0], king[1]], value: true);
      if (winnerChecker(scaffoldKey.currentContext!)) {
        await winDialog(
            context: scaffoldKey.currentContext!,
            oldPosition: oldPosition,
            pieceIndex: pieceIndex);
        return;
      }
    }
  }
  if (!isRead && context.read<RoleOrganizer>().playerNumber != null) {
    await onlineActions(context, oldPosition, pieceIndex);
  }
  // scaffoldKey.currentContext!.read<RoleOrganizer>().plusNumberOfMoves();
}

Future<void> onlineActions(BuildContext context, List<dynamic> oldPosition,
    List<dynamic> pieceIndex) async {
  var provider = context.read<OnlineGameController>();
  provider.oldMove = oldPosition;
  int numberOfMoves = context.read<RoleOrganizer>().numberOfMoves;
  provider.updateLastMove(oldPosition: oldPosition, pieceIndex: pieceIndex);
  provider.changeNumberOfMoves(numberOfMoves + 1);
  provider.saveMove(
      numberOfMove: numberOfMoves + 1,
      oldPosition: oldPosition,
      pieceIndex: pieceIndex);
}
