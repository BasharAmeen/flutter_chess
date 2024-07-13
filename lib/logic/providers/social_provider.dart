import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'auth.dart';
import 'package:http/http.dart' as http;

class Social with ChangeNotifier {
  Map allUserFullData = {};
  List<String> allUsers = [];
  List<String> get allUsersget {
    return allUsers
        .where((element) => !friendsNames.contains(element))
        .toList();
  }

  List friendsNames = [];
  String get accountEmail =>
      scaffoldKey.currentContext!.read<Auth>().accountEmail!.split('@')[0];

  Stream<DatabaseEvent> get friendsStream =>
      FirebaseDatabase.instance.ref('users/$accountEmail/friends').onValue;
  Stream<DatabaseEvent> get friendsRequestsStream => FirebaseDatabase.instance
      .ref('users/$accountEmail/friendsRequest')
      .onValue;

  Future<Map> getAllUsers() async {
    var res = await http.get(Uri.parse(
        'https://chess-d1226-default-rtdb.firebaseio.com/users.json'));

    var temp = jsonDecode(res.body) as Map;
    String accountEmail =
        scaffoldKey.currentContext!.read<Auth>().accountEmail!.split('@')[0];
    temp.remove(accountEmail);
    return temp;
  }

  Future<void> updateFullAllUserData() async {
    getAllUsers().then((value) {
      allUserFullData = value;
      allUsers.clear();
      allUserFullData.forEach((key, value) {
        allUsers.add(value['userName'] as String);
      });
    });
  }

  Future<void> addFriend(
      {required String email, required String userName}) async {
    var context = scaffoldKey.currentContext!;
    String myEmail = accountEmail;
    await http.patch(
      Uri.parse(
          'https://chess-d1226-default-rtdb.firebaseio.com/users/$myEmail/friends.json'),
      body: jsonEncode({email: userName}),
    );
    await http.patch(
      Uri.parse(
          'https://chess-d1226-default-rtdb.firebaseio.com/users/$email/friends.json'),
      body: jsonEncode({
        myEmail: context.read<Auth>().accountName,
      }),
    );
    await http.delete(
      Uri.parse(
          'https://chess-d1226-default-rtdb.firebaseio.com/users/$myEmail/friendsRequest/$email.json'),
    );
  }

  void removeFriend({required String email}) async {
    var context = scaffoldKey.currentContext!;
    String myEmail = context.read<Auth>().accountEmail!.split('@')[0];
    await http.delete(Uri.parse(
        'https://chess-d1226-default-rtdb.firebaseio.com/users/$myEmail/friends/$email.json'));
    await http.delete(Uri.parse(
        'https://chess-d1226-default-rtdb.firebaseio.com/users/$email/friends/$myEmail.json'));
  }
}
