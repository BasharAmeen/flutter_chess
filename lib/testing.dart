// // ignore_for_file: use_build_context_synchronously

// import 'package:chess/logic/providers/role_organizer.dart';
// import 'package:chess/main.dart';
// import 'package:chess/ui/widgets/game_widgets/drag_target_piece.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'logic/functions/positions_filter.dart';
// import 'logic/functions/where_can_move.dart';
// import 'logic/models/piece.dart';
// import 'logic/providers/board_provider.dart';

// import 'logic/providers/positions_provider.dart';

// Future<int> calculateNumberOfPossibleMoves(
//     int numberOfMoves, List innerBoard) 
//     async 
//     {
//   if (numberOfMoves == 7) return 0;
//   var canBeCheck = numberOfMoves < 3;
//   var currentColor = numberOfMoves.isOdd ? Colors.white : Colors.black;
//   int sum = 0;
//   for (var row = 1; row < 9; row++) {
//     for (var column = 1; column < 9; column++) {
//       var piece = innerBoard[row][column];

//       if (piece is Piece && piece.color == currentColor) {
//         var boardProvider = _context.read<Board>();
//         var positionsProvider = _context.read<Positions>();
//         getPossibleMoves(
//             [row, column], canBeCheck, boardProvider, positionsProvider);
//         List possiblePositions =
//             List.from(_context.read<Positions>().positions);
//         if (numberOfMoves == 6) sum += possiblePositions.length;
//         for (var iii = 0; iii < possiblePositions.length; iii++) {
//           Board originalBoard = _context.read<Board>().copyWith();
//           List originalPositions = List.from(possiblePositions);
//           bool originalRole = _context.read<RoleOrganizer>().isFirstPlayerRole;
//           onAccept([row, column], possiblePositions[iii], false);

//           var calculateNumberOfPossibleMoves2 =
//               calculateNumberOfPossibleMoves(numberOfMoves + 1);

//           sum += await calculateNumberOfPossibleMoves2;
//           _context.read<Board>().readCopy(originalBoard);
//           innerBoard = originalBoard.board;
//           _context.read<Positions>().positions = originalPositions;
//           _context.read<RoleOrganizer>().isFirstPlayerRole = originalRole;
//         }
//       }
//     }
//   }

//   return sum;
// }

// getPossibleMoves(List pieceIndex, bool canBeCheck, Board boardProvider,
//     Positions positionsProvider) {
//   positionsProvider.positions.clear();

//   positionsProvider.reAssign(whereCanMove(
//       piece: boardProvider.board[pieceIndex[0]][pieceIndex[1]],
//       board: boardProvider.board));

//   if (canBeCheck) {
//     positionsFilter(boardProvider, positionsProvider,
//         pieceColor:
//             boardProvider.board[pieceIndex[0]][pieceIndex[1]].color.toString(),
//         pieceIndex: pieceIndex);
//   }
//   // Update the board ui, by update "eat" list
// }
