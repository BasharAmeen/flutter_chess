import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import '../../main.dart';
import '../../ui/widgets/game_widgets/drag_target_piece.dart';
import '../functions/reset_board.dart';
import 'auth.dart';
import 'board_provider.dart';
import 'chat_provider.dart';
import 'hanging_piece_provider.dart';
import '../functions/where_can_move.dart';
import 'role_organizer.dart';

class OnlineGameController with ChangeNotifier {
  String? gameId;
  List oldMove = [];
  bool isMeRestartSender = false;
  late String enemyName;
  late String enemyEmail;
  late String enemyImage = "assets/Images/profile.jpg";
  late Stream<DatabaseEvent> _restartRequestStream;
  final FirebaseDatabase _fireInstance = FirebaseDatabase.instance;
  final BuildContext _context = scaffoldKey.currentContext!;
  final _urlOfDB = 'https://chess-d1226-default-rtdb.firebaseio.com';
  late StreamSubscription<DatabaseEvent> _restartSubscription;
  late StreamSubscription<DatabaseEvent> _gameSubscription;
  late StreamSubscription<DatabaseEvent> _givingUpSubscription;

  void _resetGameDataOnCloud() async {
    String gameUrl = '$_urlOfDB/games/$gameId';
    for (var i = 1; i <= _context.read<RoleOrganizer>().numberOfMoves; i++) {
      http.delete(Uri.parse('$gameUrl/$i.json'));
    }
    changeNumberOfMoves(0);
    await http.delete(Uri.parse('$gameUrl/lastMove.json'));
  }

  void restartGameRequest() async {
    await http.put(
      Uri.parse('$_urlOfDB/games/$gameId/restartRequest.json'),
      body: json.encode({'restartRequest': _context.read<Auth>().accountName}),
    );
    isMeRestartSender = true;

    showToastWidget(
      containerOfToast(
        child: const Text(
          "  Restart request sent ..  ",
          style: TextStyle(color: Colors.green, fontSize: 20),
        ),
      ),
      context: _context,
    );
  }

  void _listenToRestartRequestStream() async {
    _restartRequestStream = _fireInstance
        .ref('games/$gameId/restartRequest/restartRequest')
        .onValue;
    _restartSubscription = _restartRequestStream.listen((event) async {
      String data = event.snapshot.value.toString();
      if (data == 'null') {
        return;
      }

      if (data == 'true' && isMeRestartSender == true) {
        _showResponseToast(' accepted  ');
        _restartRequestStream;
        resetGame();
        isMeRestartSender = false;
      } else if (data == 'false' && isMeRestartSender == true) {
        _showResponseToast(' Ignored  ');
        await _deleteRestartRequest();
      } else if (data == enemyName) {
        showDialog(
          context: _context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                data,
                style: const TextStyle(color: Colors.amber),
              ),
              content: const Text(' -want to rematch'),
              actions: [
                OutlinedButton(
                    onPressed: () async {
                      await http.put(
                          Uri.parse(
                              '$_urlOfDB/games/$gameId/restartRequest/restartRequest.json'),
                          body: 'false');
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Ignore',
                      style: TextStyle(color: Colors.red[300], fontSize: 16),
                    )),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                    onPressed: () async {
                      resetGame();
                      _resetGameDataOnCloud();
                      showToastWidget(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 8),
                          margin: const EdgeInsets.symmetric(horizontal: 50.0),
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            color: Colors.black,
                          ),
                          child: const Text(
                            '  Rematched ',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        context: context,
                      );
                      await http.put(
                        Uri.parse(
                            'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/restartRequest/restartRequest.json'),
                        body: 'true',
                      );

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Accept',
                      style: TextStyle(color: Colors.green[600], fontSize: 16),
                    ))
              ],
            );
          },
        );
      }
    });
  }

  void _listenToGameStream() {
    Stream<DatabaseEvent> gameStream =
        _fireInstance.ref('games/$gameId/lastMove').onValue;
    _gameSubscription = gameStream.listen((event) async {
      var value = event.snapshot.value;

      if (value == null) {
        return;
      }
      Map? lastMoveMap = event.snapshot.value as Map;
      if (oldMove.toString() == lastMoveMap['from'].toString()) {
        return;
      }
      List oldP = lastMoveMap['from'];
      List newP = lastMoveMap['to'];

      await onAccept(oldP, newP, true);
      await removeLastMove();
    });
  }

  void _listenToGivingUp() async {
    var givingUpStrem = _fireInstance.ref('games/$gameId/givingUp').onValue;
    _givingUpSubscription = givingUpStrem.listen((event) {
      var data = event.snapshot.value as Map?;

      if (data?['playerName'] == enemyName) {
        scaffoldKey.currentContext!
            .read<RoleOrganizer>()
            .numberOfMovesValueChanger(-1);
        showDialog(
          context: _context,
          builder: (_) => AlertDialog(
            title: Row(
              children: [
                Text(
                  '$enemyName ',
                  style: TextStyle(fontSize: 20, color: Colors.amber[600]),
                ),
                const Text(
                  ' is give up',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            content: const Text('- You won this game',
                style: TextStyle(fontSize: 15, color: Colors.white)),
          ),
        );
      }
    });
  }

  void stopListening() async {
    await _restartSubscription.cancel();
    await _gameSubscription.cancel();
    await _givingUpSubscription.cancel();
  }

  void givingUp() async {
    var authProvider = _context.read<Auth>();
    await _fireInstance
        .ref('games/$gameId')
        .child('givingUp')
        .set({'playerName': authProvider.accountName});
    deleteChallenge();
    stopListening();
  }

  void deleteChallenge() {
    _deleteChallenge(email: enemyEmail.split('@')[0]);
    _deleteChallenge(email: _context.read<Auth>().accountEmail!.split('@')[0]);
  }

  void _deleteChallenge({required String email}) async {
    await http.delete(
      Uri.parse('$_urlOfDB/users/$email/challenges.json'),
    );
  }

  Future<void> _deleteRestartRequest() async {
    await http.delete(Uri.parse(
        'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/restartRequest.json'));
    isMeRestartSender = false;
  }

  // Future<void> postWin({required String nameOfWinner}) async {
  //   await http.put(
  //       Uri.parse(
  //           'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/whoWin.json'),
  //       body: json.encode({
  //         'whoWin': nameOfWinner,
  //       }));
  // }

  Future<void> removeLastMove() async {
    await http.delete(Uri.parse(
        'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/lastMove.json'));
  }

  void applyMove(Map<dynamic, dynamic> lastMoveMap) {
    List oldP = lastMoveMap['from'];
    oldMove = oldP;
    List newP = lastMoveMap['to'];
    _context.read<Board>().swapPoints(pointOne: oldP, pointTwo: newP);

    _context.read<Board>().board[newP[0]][newP[1]].yAxis = newP[0];
    _context.read<Board>().board[newP[0]][newP[1]].xAxis = newP[1];
    //Checkig if there is check
    List king = _context.read<RoleOrganizer>().playerNumber == 1
        ? _context.read<Board>().whiteKing.position
        : _context.read<Board>().blackKing.position;

    if (_context.read<Board>().board[newP[0]][newP[1]] != true) {
      if (whereCanMove(
              piece: _context.read<Board>().board[newP[0]][newP[1]],
              board: _context.read<Board>().board)
          .any((element) => element[0] == king[0] && element[1] == king[1])) {
        _context
            .read<HangingPiece>()
            .pointValueChanger(point: [...king], value: true);
      }
    }
    _context.read<RoleOrganizer>().changeRole();
  }

  Future<void> createNewGame() async {
    var res = await http.post(
        Uri.parse('https://chess-d1226-default-rtdb.firebaseio.com/games.json'),
        body: json.encode({'numberOfMoves': 0, 'isStart': ''}));

    gameId = (json.decode(res.body) as Map)['name'];
    _context.read<RoleOrganizer>().playerNumber = 1;
    _context.read<Chat>().init();
    _listenToGameStream();
    _listenToRestartRequestStream();
    _listenToGivingUp();
  }

  Future<int> numberOfMoves() async {
    var res = await http.get(
      Uri.parse('$_urlOfDB/games/$gameId/numberOfMoves.json'),
    );

    return json.decode(res.body) as int;
  }

  void changeNumberOfMoves(int newValue) async {
    await http.put(
        Uri.parse(
            'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/numberOfMoves.json'),
        body: json.encode(newValue));
  }

  void updateLastMove(
      {required List oldPosition, required List pieceIndex}) async {
    await _fireInstance
        .ref('games/$gameId/lastMove')
        .set({'from': oldPosition, 'to': pieceIndex});
  }

  void saveMove(
      {required numberOfMove,
      required List oldPosition,
      required List pieceIndex}) async {
    await http.put(
      Uri.parse(
          'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/${numberOfMove + 1}.json'),
      body: json.encode({'from': oldPosition, 'to': pieceIndex}),
    );
  }

  void ignoreChallenge({required String gameId, required String email}) async {
    await http.put(
        Uri.parse(
            'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/isStart.json'),
        body: 'false');
    _deleteChallenge(email: email);
  }

  Future<void> acceptChallenge(
      {required String gameId,
      required String enemyName,
      required enemyEmail}) async {
    var ctx = _context;
    var rolerProvider = ctx.read<RoleOrganizer>();
    await http.put(
        Uri.parse(
            'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/isStart.json'),
        body: 'true');
    this.gameId = gameId;

    this.enemyName = enemyName;
    this.enemyEmail = enemyEmail;
    int movesNumber = await numberOfMoves();
    if (movesNumber != 0) {
      ctx.read<Board>().reset();

      for (int i = 1; i <= movesNumber; i++) {
        Map move = json.decode((await http.get(Uri.parse(
                'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/$i.json')))
            .body) as Map;
        applyMove(move);
        if (i == movesNumber) {
          await http.delete(Uri.parse(
              'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/lastMove.json'));
        }
      }
    }
    rolerProvider.isFirstPlayerRole = movesNumber % 2 == 0;
    _listenToGameStream();
    _listenToRestartRequestStream();
    _listenToGivingUp();
    rolerProvider.playerNumber = 2;
    _context.read<Chat>().init();
  }
}

ToastFuture _showResponseToast(final String requestResponse) {
  return showToastWidget(
    containerOfToast(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
      const Text('  Restart request ',
          style: TextStyle(fontSize: 17, color: Colors.white)),
      Text(requestResponse,
          style: TextStyle(
              color: requestResponse.trim() == 'Ignored'
                  ? Colors.red[400]
                  : Colors.amber,
              fontSize: 20))
    ])),
    context: scaffoldKey.currentContext!,
  );
}

Container containerOfToast({required Widget child}) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 50.0),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        color: Colors.black,
      ),
      child: child);
}
