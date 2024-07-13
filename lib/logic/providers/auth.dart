import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../ui/configuration/themes.dart';
import '../../ui/screens/signing/auth_screen.dart';

class Auth with ChangeNotifier {
  String? _idToken, _localId;
  DateTime? _expiresIn;
  Timer? timer;
  String? accountName;
  String? accountEmail;
  bool get isAuth {
    return idToken != null;
  }

  String? get idToken {
    if (_expiresIn != null &&
        _expiresIn!.isAfter(DateTime.now()) &&
        _idToken != null) {
      return _idToken;
    }
    return null;
  }

  Future<void> _authentication(
      {required String email,
      required String password,
      required String urlSegment,
      String? userName}) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCy-A0cU8dE7vWjKPvmzZmK-A23JZFjZSE';
    final uri = Uri.parse(url);

    try {
      final res = await http.post(
        uri,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final resData = json.decode(res.body);
      if (resData['error'] != null) {
        throw "${resData['error']['message']}";
      }
      if (urlSegment == 'signUp') {
        var res2 = await http.patch(
            Uri.parse(
                'https://chess-d1226-default-rtdb.firebaseio.com/users.json'),
            body: json.encode({
              email.split('@')[0]: {'userName': userName}
            }));
        if (res.body == 'null' ||
            (jsonDecode(res2.body) as Map).containsKey('error')) {
          throw (jsonDecode(res2.body) as Map)['error'];
        }
      }

      if (urlSegment != 'signUp') {
        var getName = await http.get(
          Uri.parse(
              'https://chess-d1226-default-rtdb.firebaseio.com/users/${email.split('@')[0]}/userName.json'),
        );

        accountName = json.decode(getName.body);
        _idToken = resData['idToken'];
        _localId = resData['localId'];
        _expiresIn = DateTime.now()
            .add(Duration(seconds: int.parse(resData['expiresIn'])))
            .add(const Duration(days: 7));
        accountEmail = email;

        autoLogout();
        var pref = await SharedPreferences.getInstance();
        var data = json.encode({
          'idToken': _idToken,
          'localId': _localId,
          'expiresIn': _expiresIn!.toIso8601String(),
          'accountName': accountName,
          'accountEmail': email,
        });
        await pref.setString('account data', data);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    var pref = await SharedPreferences.getInstance();

    if (!pref.containsKey('account data')) {
      return false;
    }
    final data = json.decode(pref.getString('account data')!) as Map;
    final expiresIn = DateTime.parse(data['expiresIn']);
    if (expiresIn.isBefore(DateTime.now())) {
      return false;
    }
    _expiresIn = expiresIn;
    _idToken = data['idToken'];
    _localId = data['localId'];
    accountName = data['accountName'];
    accountEmail = data['accountEmail'];
    notifyListeners();
    autoLogout();
    scaffoldKey.currentContext!.read<Themes>().swithMode(true);

    return true;
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String userName,
  }) async {
    return await _authentication(
        email: email,
        password: password,
        urlSegment: 'signUp',
        userName: userName);
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    return await _authentication(
      email: email,
      password: password,
      urlSegment: 'signInWithPassword',
    );
  }

  void logout() async {
    _expiresIn = null;
    _idToken = null;
    _localId = null;
    var pref = await SharedPreferences.getInstance();
    pref.clear();
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    scaffoldKey.currentContext!.read<Themes>().swithMode(false);
    Navigator.of(scaffoldKey.currentContext!).push(MaterialPageRoute(
      builder: (_) => const AuthScreen(isLogin: true),
    ));
    notifyListeners();
  }

  void autoLogout() {
    if (timer != null) {
      timer!.cancel();
      timer = null;
    }
    final timeToLogout = _expiresIn!.difference(DateTime.now()).inSeconds;
    timer = Timer(Duration(seconds: timeToLogout), logout);
  }
}
