import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../ui/configuration/themes.dart';
import 'auth.dart';
import 'board_provider.dart';
import 'chat_provider.dart';
import 'hanging_piece_provider.dart';
import 'online_game_controller.dart';
import 'positions_provider.dart';
import 'role_organizer.dart';
import 'social_provider.dart';
import 'timer_controller.dart';

List<SingleChildWidget> multiProvidersList() {
  return <SingleChildWidget>[
    ChangeNotifierProvider(create: (_) => Board()),
    ChangeNotifierProvider(create: (_) => HangingPiece()),
    ChangeNotifierProvider(create: (_) => Positions()),
    ChangeNotifierProvider(create: (_) => RoleOrganizer()),
    ChangeNotifierProvider(create: (_) => TimerController(initialMinutes: 11)),
    ChangeNotifierProvider(create: (_) => Themes()),
    ChangeNotifierProvider(create: (_) => OnlineGameController()),
    ChangeNotifierProvider(create: (_) => Auth()),
    ChangeNotifierProvider(create: (_) => Social()),
    ChangeNotifierProvider(create: (_) => Chat()),
  ];
}
