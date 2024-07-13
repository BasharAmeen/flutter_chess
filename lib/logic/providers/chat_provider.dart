import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import '../../main.dart';
import '../models/message.dart';
import 'auth.dart';
import 'online_game_controller.dart';

class Chat with ChangeNotifier {
  void init() {
    gameId = context.read<OnlineGameController>().gameId!;
    chatUrl =
        'https://chess-d1226-default-rtdb.firebaseio.com/games/$gameId/chat';
    firebaseRef = FirebaseDatabase.instance.ref('games/$gameId/chat');
    myName = context.read<Auth>().accountName!;
    _listenToStrem();
    // TODO : Implement on rejoin game--> read messages
  }

  int numberOfMesseges = 0;
  bool thereIsUnreadedMesseges = false;
  void changeThereIsUnreadedMesseges(bool newValue) {
    thereIsUnreadedMesseges = newValue;

    notifyListeners();
  }

  var context = scaffoldKey.currentContext!;
  String chatUrl = '';
  String gameId = '';
  DatabaseReference? firebaseRef;
  int get numberOfMessages => allMessages.length;
  List<Message> allMessages = [];
  TextEditingController textController = TextEditingController();
  late String myName;
  void _listenToStrem() {
    firebaseRef!.onChildAdded.listen((event) {
      Message message = Message.fromMap(event.snapshot.value as Map);

      if (message.isMe()) return;
      allMessages.add(message);
      numberOfMesseges = allMessages.length;
      thereIsUnreadedMesseges = true;
      notifyListeners();
    });
  }

  void sendMessage() async {
    String messageText = textController.text.trim();
    Message message =
        Message(message: messageText, time: DateTime.now(), sender: myName);
    allMessages.add(message);
    textController.clear();
    numberOfMesseges = allMessages.length;

    notifyListeners();
    await firebaseRef!.child('$numberOfMessages').set(message.toMap());
  }
}
