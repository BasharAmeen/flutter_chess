import 'package:provider/provider.dart';

import '../../main.dart';

import '../providers/board_provider.dart';
import '../providers/hanging_piece_provider.dart';
import '../providers/positions_provider.dart';
import '../providers/role_organizer.dart';
import '../providers/timer_controller.dart';

void resetGame() {
  var context = scaffoldKey.currentContext!;
  context.read<Board>().reset();
  context.read<RoleOrganizer>().reset();
  context.read<HangingPiece>().setAllFalse();
  context.read<Positions>().reset();
  context.read<TimerController>().reset();
}
