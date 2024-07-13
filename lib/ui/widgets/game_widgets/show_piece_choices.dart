import 'package:flutter/material.dart';

import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

import '../../../logic/providers/board_provider.dart';
import '../../../logic/models/bishop.dart';
import '../../../logic/models/knight.dart';
import '../../../logic/models/queen.dart';
import '../../../logic/models/rook.dart';
import '../../../logic/providers/role_organizer.dart';
import '../../../main.dart';

showPieceChoices(BuildContext context, List pieceIndex) async {
  iconButtonMaker({required IconData icon, required int value}) {
    return Builder(builder: (ctx) {
      return InkWell(
        onTap: () {
          var boardProvider = scaffoldKey.currentContext!.read<Board>();
          scaffoldKey.currentContext!
              .read<Board>()
              .reAssignChoosenPieceToReplacePawn(value);

          switch (boardProvider.choosenPieceToReplacePawn) {
            case 1:
              boardProvider.changeBoardVale(
                  pieceIndex,
                  Queen(
                      xAxis: pieceIndex[1],
                      yAxis: pieceIndex[0],
                      color: boardProvider
                          .board[pieceIndex[0]][pieceIndex[1]].color));

              break;
            case 2:
              boardProvider.changeBoardVale(
                  pieceIndex,
                  Rook(
                      xAxis: pieceIndex[1],
                      yAxis: pieceIndex[0],
                      color: boardProvider
                          .board[pieceIndex[0]][pieceIndex[1]].color));
              break;
            case 3:
              boardProvider.changeBoardVale(
                  pieceIndex,
                  Knight(
                      xAxis: pieceIndex[1],
                      yAxis: pieceIndex[0],
                      color: boardProvider
                          .board[pieceIndex[0]][pieceIndex[1]].color));
              break;
            case 4:
              boardProvider.changeBoardVale(
                  pieceIndex,
                  Bishop(
                      xAxis: pieceIndex[1],
                      yAxis: pieceIndex[0],
                      color: boardProvider
                          .board[pieceIndex[0]][pieceIndex[1]].color));
          }

          Navigator.of(ctx).pop();
        },
        child: Icon(
          icon,
          size: MediaQuery.of(context).size.width / 15,
          color: scaffoldKey.currentContext!
                  .read<RoleOrganizer>()
                  .isFirstPlayerRole
              ? Colors.white
              : Colors.black,
        ),
      );
    });
  }

  var alert = AlertDialog(
      title: Center(
          child: Text(
        'Select piece : \n',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.width / 17,
          fontWeight: FontWeight.bold,
        ),
      )),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconButtonMaker(icon: FontAwesome5.chess_queen, value: 1),
          const SizedBox(
            width: 13,
          ),
          iconButtonMaker(icon: FontAwesome5.chess_rook, value: 2),
          const SizedBox(
            width: 13,
          ),
          iconButtonMaker(icon: FontAwesome5.chess_knight, value: 3),
          const SizedBox(
            width: 13,
          ),
          iconButtonMaker(icon: FontAwesome5.chess_bishop, value: 4),
        ],
      ));
  await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return alert;
      });
}
