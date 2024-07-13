import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../../logic/providers/auth.dart';
import '../../../logic/providers/online_game_controller.dart';
import '../../../logic/providers/social_provider.dart';

import '../../configuration/responsive.dart';
import '../../screens/enemy_waiting.dart';
import '../../screens/game_screen.dart';
import 'profile.dart';

class FriendsWidget extends StatelessWidget {
  const FriendsWidget({super.key, this.width});
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: StreamBuilder<DatabaseEvent>(
          stream: context.read<Social>().friendsStream,
          builder: (context, snapshot) {
            bool isWating = snapshot.connectionState == ConnectionState.waiting;
            Map? snapshotData = snapshot.data != null
                ? (snapshot.data!.snapshot.value as Map?)
                : null;
            List friendsNames =
                snapshotData != null ? snapshotData.values.toList() : [];
            List friendsEmails =
                snapshotData != null ? snapshotData.keys.toList() : [];
            Offset tapXY = const Offset(0, 0);
            context.read<Social>().friendsNames = friendsNames;
            return Column(
              children: [
                FriendsHeader(text: '    Online', width: width),
                Stack(
                  children: [
                    const Profile(
                      name: 'Bashar.ro',
                      image: AssetImage('images/app_icon.webp'),
                      level: 10,
                      isFriend: true,
                    ),
                    Positioned(
                      left: 18,
                      top: 10,
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withOpacity(0.4),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const FriendsHeader(text: '    Offline'),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      if (isWating) const SizedBox(height: 100),
                      if (isWating)
                        Center(
                            child: CircularProgressIndicator(
                                color: Colors.green[400])),
                      ...List.generate(
                          friendsNames.length,
                          (index) => GestureDetector(
                                onTapDown: (details) =>
                                    tapXY = details.globalPosition,
                                onTap: () {
                                  showMenu(
                                      context: context,
                                      constraints: const BoxConstraints(
                                        maxWidth: 150,
                                      ),
                                      position: RelativeRect.fromSize(
                                          tapXY & const Size(40, 40),
                                          const Size(double.infinity,
                                              double.infinity)),
                                      items: [
                                        const PopupMenuItem(
                                          value: 1,
                                          child: Text("Profile"),
                                        ),
                                        PopupMenuItem(
                                          onTap: () async {
                                            await friendlyBattle(
                                                context,
                                                friendsNames[index],
                                                friendsEmails[index]);
                                          },
                                          value: 2,
                                          child: const Text(
                                            "Friendly Battle",
                                            style: TextStyle(
                                              color: Colors.amber,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        PopupMenuItem(
                                          onTap: () {
                                            context.read<Social>().removeFriend(
                                                email: friendsEmails[index]);
                                          },
                                          value: 2,
                                          child: const Text(
                                            "Remove friend",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ]);
                                },
                                child: Stack(
                                  children: [
                                    Profile(
                                      isFriend: true,
                                      name: friendsNames[index],
                                      image: const AssetImage(
                                          'images/app_icon.webp'),
                                      level: 10,
                                    ),
                                    Positioned(
                                      left: 18,
                                      top: 10,
                                      child: Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green.withOpacity(0.4),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> friendlyBattle(
      BuildContext context, String friendName, String friendEmail) async {
    var provider = context.read<OnlineGameController>();
    await provider.createNewGame();

    var authProvider = context.read<Auth>();
    http.patch(
      Uri.parse(
          'https://chess-d1226-default-rtdb.firebaseio.com/users/$friendEmail/challenges.json'),
      body: json.encode({
        'name': authProvider.accountName,
        'gameId': provider.gameId,
        'email': authProvider.accountEmail!.split('@')[0]
      }),
    );

    context.read<OnlineGameController>().enemyName = friendName;
    context.read<OnlineGameController>().enemyEmail = friendEmail;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EnemyWaiting(nameOfEnemy: friendName),
    ));
    Stream? stream = FirebaseDatabase.instance
        .ref('games/${provider.gameId}/isStart')
        .onValue;

    stream.listen((event) {
      var data = event.snapshot.value.toString();

      if (data == 'null') return;
      if (data == 'true') {
        stream = null;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const GameScreen(),
        ));
      }
      if (data == 'false') {
        stream = null;
        showToastWidget(
          containerOfToast(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                '  $friendName',
                style: const TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                ),
              ),
              const Text(
                ', ignored the invite',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ]),
          ),
          context: context,
        );

        Navigator.of(context).pop();
      }
    });
  }
}

class FriendsHeader extends StatelessWidget {
  const FriendsHeader({
    Key? key,
    required this.text,
    this.width,
  }) : super(key: key);
  final String text;
  final double? width;
  @override
  Widget build(BuildContext context) {
    double screenWidth = width ?? MediaQuery.of(context).size.width;
    double dividerWidth = (screenWidth / 2) - 50;
    bool isDesktop = Responsive.isDesktop(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: isDesktop ? screenWidth / 7.54 : dividerWidth,
            child: const Divider(
              color: Colors.grey,
              thickness: 1,
            )),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        SizedBox(
            width: isDesktop ? screenWidth / 7.54 : dividerWidth,
            child: const Divider(
              color: Colors.grey,
              thickness: 1,
            )),
      ],
    );
  }
}
