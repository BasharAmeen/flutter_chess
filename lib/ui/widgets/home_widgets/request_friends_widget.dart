import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../logic/providers/auth.dart';
import '../../../logic/providers/online_game_controller.dart';
import '../../../logic/providers/social_provider.dart';
import 'profile.dart';

class RequestFriendsWidget extends StatelessWidget {
  const RequestFriendsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: StreamBuilder<DatabaseEvent>(
          stream: context.read<Social>().friendsRequestsStream,
          builder: (context, snapshot) {
            bool isWating = snapshot.connectionState == ConnectionState.waiting;
            Map? snapshotData = snapshot.data?.snapshot.value != null
                ? (snapshot.data!.snapshot.value as Map)
                : null;
            Offset tapXY = const Offset(0, 0);

            List friendsReqestNames =
                snapshotData != null ? snapshotData.values.toList() : [];
            List friendsReqestEmails =
                snapshotData != null ? snapshotData.keys.toList() : [];
            return isWating
                ? const CircularProgressIndicator.adaptive()
                : friendsReqestNames.isEmpty
                    ? const Center(
                        child: Text(
                        'There is no friend requests ..',
                      ))
                    : Column(
                        children: List.generate(
                            friendsReqestNames.length,
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
                                          PopupMenuItem(
                                            onTap: () async {
                                              await accept(
                                                  context,
                                                  friendsReqestNames[index],
                                                  friendsReqestEmails[index]);
                                            },
                                            value: 1,
                                            child: const Row(
                                              children: [
                                                Text(
                                                  "Accept    ",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                                Icon(Icons.done),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () async {
                                              await http.delete(Uri.parse(
                                                  'https://chess-d1226-default-rtdb.firebaseio.com/users/${context.read<Auth>().accountEmail!.split('@')[0]}/friendsRequest.json'));
                                            },
                                            value: 2,
                                            child: const Row(
                                              children: [
                                                Text(
                                                  "Remove    ",
                                                  style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ]);
                                  },
                                  child: Profile(
                                      image: const AssetImage(
                                        'assets/Images/profile.jpg',
                                      ),
                                      level: 10,
                                      name: friendsReqestNames[index]),
                                )));
          }),
    );
  }

  Future<void> accept(BuildContext context, String friendsReqestName,
      String friendsReqestEmail) async {
    var socialProvider = context.read<Social>();
    await socialProvider.addFriend(
        email: friendsReqestEmail, userName: friendsReqestName);

    showToastWidget(
      containerOfToast(
          child: const Text(
        '  Added  ',
        style: TextStyle(
          fontSize: 18,
          color: Colors.teal,
        ),
      )),
      context: context,
    );
  }
}
