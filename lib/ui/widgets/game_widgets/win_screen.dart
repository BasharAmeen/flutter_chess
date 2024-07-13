import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../logic/providers/board_provider.dart';
import '../../../logic/providers/role_organizer.dart';
import '../../../main.dart';
import 'drag_target_piece.dart';

winDialog({
  required BuildContext context,
  List? pieceIndex,
  List? oldPosition,
}) async {
  var isPlayerOneWin = context.read<Board>().isPlayerOneWin;
  var alert = AlertDialog(
    title: Center(
      child: Text(context.read<RoleOrganizer>().playerNumber != null
          ? isPlayerOneWin == true
              ? context.read<RoleOrganizer>().playerNumber == 1
                  ? "You Won!"
                  : "You Lost!"
              : context.read<RoleOrganizer>().playerNumber == 2
                  ? "You Won!"
                  : "You Lost!"
          : isPlayerOneWin == true
              ? "Player One Won!"
              : "Player Two Won!"),
    ),
  );

  scaffoldKey.currentContext!
      .read<RoleOrganizer>()
      .numberOfMovesValueChanger(-1);

  await showDialog(
    context: context,
    builder: (_) {
      if (pieceIndex != null) {
        onlineActions(context, oldPosition!, pieceIndex);

        // var isPlayerOne = context.read<RoleOrganizer>().playerNumber == 1;
        // context.read<OnlineGameController>().postWin(
        //     nameOfWinner: isPlayerOneWin == true
        //         ? isPlayerOne
        //             ? context.read<Auth>().accountName!
        //             : context.read<OnlineGameController>().enemyName
        //         : !isPlayerOne
        //             ? context.read<Auth>().accountName!
        //             : context.read<OnlineGameController>().enemyName);
      }
      return alert;
    },
  );
}
