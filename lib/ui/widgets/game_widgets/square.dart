import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../logic/providers/board_provider.dart';
import '../../../logic/providers/hanging_piece_provider.dart';

import '../../../logic/providers/role_organizer.dart';
import 'drag_target_piece.dart';
import 'dragable_piece.dart';

class Square extends StatelessWidget {
  final chars = [null, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
  final int index;
  final List pieceIndex;
  Square({
    Key? key,
    required this.index,
    required this.pieceIndex,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);
  final double screenHeight;
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      Board boardProvider = context.read<Board>();
      RoleOrganizer roleProvider = context.read<RoleOrganizer>();
      bool isHanging = context.select<HangingPiece, bool>(
          (value) => value.hangingPiece[pieceIndex[0]][pieceIndex[1]]);
      var thePiece = context.select<Board, dynamic>(
          (value) => value.board[pieceIndex[0]][pieceIndex[1]]);
      var thePieceColor = thePiece != true ? thePiece.color : null;
      var icon = thePiece != true ? thePiece.icon : null;
      bool isEmptySquare = icon == null;
      var colorOfSquare =
          index % 2 == 0 ? const Color(0xffbebebe) : const Color(0xff242424);

      var isKingSelcted = ((boardProvider.blackKing.position.toString() ==
              pieceIndex.toString()) ||
          (pieceIndex.toString() ==
              boardProvider.whiteKing.position.toString()));
      var isCastling = ((roleProvider.isFirstPlayerRole &&
              thePieceColor.toString() == Colors.white.toString() ||
          !roleProvider.isFirstPlayerRole &&
              thePieceColor.toString() == Colors.black.toString()));
      return Stack(
        children: [
          Container(
            width: screenWidth / 8,
            height: screenWidth / 8,
            color: colorOfSquare,
            child: isEmptySquare
                ? isHanging
                    ? Stack(alignment: Alignment.center, children: [
                        IconButton(
                          icon: Container(
                            width: screenWidth / 25,
                            height: screenWidth / 25,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                          ),
                          onPressed: () async {
                            await onAccept(
                                boardProvider.selctedPiece, pieceIndex, false);
                          },
                        ),
                        DragTargetPiece(pieceIndex: pieceIndex),
                      ])
                    : null
                : Stack(alignment: Alignment.center, children: [
                    if (isHanging)
                      Container(
                        width: MediaQuery.of(context).size.width / 8,
                        height: MediaQuery.of(context).size.height / 8,
                        decoration: isKingSelcted
                            ? BoxDecoration(
                                color: Colors.red.withOpacity(0.6),
                              )
                            : isCastling
                                ? BoxDecoration(
                                    color:
                                        const Color.fromARGB(184, 39, 168, 39)
                                            .withOpacity(0.6),
                                  )
                                : BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: index % 2 == 0
                                        ? const Color(0xffbebebe)
                                        : const Color(0xff242424),
                                    border: Border.all(
                                        color: Colors.red.withOpacity(0.6),
                                        width: 4),
                                  ),
                      ),
                    DragablePiece(
                      icon: icon,
                      thePieceColor: thePieceColor,
                      pieceIndex: pieceIndex,
                      screenWidth: screenWidth,
                    ),
                    if (isHanging && !isKingSelcted)
                      GestureDetector(
                        child: Container(
                          color: Colors.transparent,
                          width: screenWidth / 8,
                          height: screenWidth / 8,
                        ),
                        onTap: () async {
                          await onAccept(
                              boardProvider.selctedPiece, pieceIndex, false);
                        },
                      ),
                    if (isHanging && !isKingSelcted)
                      DragTargetPiece(pieceIndex: pieceIndex),
                  ]),
          ),
          //===================

          if (pieceIndex[0] == 1)
            Positioned(
              bottom: 3,
              left: (screenWidth / 8) - (screenWidth / 39),
              child: Text(
                '${chars[pieceIndex[1]]}',
                style: TextStyle(
                  fontSize: (screenWidth / 8) - (screenWidth / 10),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (pieceIndex[1] == 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(3, 3, 0, 0),
              child: Text(
                '${pieceIndex[0]}',
                style: TextStyle(
                  fontSize: (screenWidth / 8) - (screenWidth / 10),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      );
    });
  }
}
