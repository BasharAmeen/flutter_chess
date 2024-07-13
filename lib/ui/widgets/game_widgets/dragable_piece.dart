import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../../main.dart';

import '../../../logic/providers/board_provider.dart';
import '../../../logic/providers/hanging_piece_provider.dart';
import '../../../logic/functions/positions_filter.dart';
import '../../../logic/providers/positions_provider.dart';
import '../../../logic/providers/role_organizer.dart';
import '../../../logic/functions/where_can_move.dart';

class DragablePiece extends StatelessWidget {
  final IconData icon;
  final Color? thePieceColor;
  final List pieceIndex;

  const DragablePiece({
    Key? key,
    required this.icon,
    this.thePieceColor,
    required this.pieceIndex,
    required this.screenWidth,
  }) : super(key: key);
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      double size = screenWidth / 12;

      return Draggable(
        onDragEnd: (details) {
          context.read<Board>().changeIsWidgetDraged(false);
        },
        maxSimultaneousDrags:
            scaffoldKey.currentContext!.watch<RoleOrganizer>().numberOfMoves ==
                    -1
                ? 0
                : context.read<RoleOrganizer>().playerNumber != null
                    ? context.watch<RoleOrganizer>().isFirstPlayerRole
                        ? (context.watch<RoleOrganizer>().playerNumber == 1) &&
                                (thePieceColor.toString() ==
                                    Colors.white.toString())
                            ? 1
                            : 0
                        : (context.watch<RoleOrganizer>().playerNumber == 2) &&
                                (thePieceColor.toString() ==
                                    Colors.black.toString())
                            ? 1
                            : 0
                    : context.watch<RoleOrganizer>().isFirstPlayerRole
                        ? thePieceColor == Colors.white
                            ? 1
                            : 0
                        : thePieceColor == Colors.black
                            ? 1
                            : 0,
        feedback: Icon(
          icon,
          size: size,
          color: thePieceColor,
        ),
        childWhenDragging: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 229, 192, 80),
        ),
        onDragStarted: () async {
          context.read<Board>().changeIsWidgetDraged(true);
          Positions positionsProvider = context.read<Positions>();
          Board boardProvider = context.read<Board>();
          HangingPiece hangingPieceProvider = context.read<HangingPiece>();
          if (boardProvider.selctedPiece.toString() == pieceIndex.toString()) {
            return;
          }
          // Get all positions without checking "king safety"
          for (var i = 0; i < positionsProvider.positions.length; i++) {
            hangingPieceProvider.pointValueChanger(
                point: positionsProvider.positions[i], value: false);
          }
          positionsProvider.positions.clear();

          positionsProvider.reAssign(whereCanMove(
              piece: boardProvider.board[pieceIndex[0]][pieceIndex[1]],
              board: boardProvider.board));

          positionsFilter(
              context: context,
              pieceColor: thePieceColor.toString(),
              pieceIndex: pieceIndex);
          // Update the board ui, by update "eat" list

          for (int i = 0; i < positionsProvider.positions.length; i++) {
            hangingPieceProvider.pointValueChanger(point: [
              positionsProvider.positions[i][0],
              positionsProvider.positions[i][1]
            ], value: true);
          }
          boardProvider.selctedPiece = pieceIndex;
        },
        data: [...pieceIndex],
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          color: const Color(0x00ffffff),
          child: Icon(
            icon,
            size: size,
            color: thePieceColor,
          ),
        ),
      );
    });
  }
}
