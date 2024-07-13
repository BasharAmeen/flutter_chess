import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../logic/providers/online_game_controller.dart';

class EnemyWaiting extends StatelessWidget {
  const EnemyWaiting({super.key, required this.nameOfEnemy});
  final String nameOfEnemy;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool answer = false;

        await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: const Text('Do you want to leave the challenge?'),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              var provider =
                                  context.read<OnlineGameController>();
                              await http.delete(Uri.parse(
                                  'https://chess-d1226-default-rtdb.firebaseio.com/games/${provider.gameId}.json'));
                              await http.delete(Uri.parse(
                                  'https://chess-d1226-default-rtdb.firebaseio.com/users/${provider.enemyEmail}/challenges.json'));
                              provider.gameId = null;
                              provider.enemyName = '';

                              answer = true;
                              Navigator.of(context).pop();
                              return;
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Leave  ',
                                  style: TextStyle(
                                      color: Colors.red[300], fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              children: const [
                                Text(
                                  'Stay  ',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ]));
        return answer;
      },
      child: Scaffold(
        body: Center(
            child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Text('Wating for $nameOfEnemy ...'),
          ],
        )),
      ),
    );
  }
}
