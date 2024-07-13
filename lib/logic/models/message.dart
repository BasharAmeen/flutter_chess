// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:provider/provider.dart';

import '../../main.dart';
import '../providers/auth.dart';

class Message {
  static bool? wasMe;
  static bool isChanged = false;
  String message;
  String sender;
  bool isMe() => scaffoldKey.currentContext!.read<Auth>().accountName == sender;
  DateTime time;
  Message({
    required this.message,
    required this.time,
    required this.sender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'sender': sender,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map map) {
    return Message(
      message: map['message'] as String,
      sender: map['sender'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
