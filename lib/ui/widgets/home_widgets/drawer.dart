import 'package:flutter/material.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:provider/provider.dart';

import '../../../logic/providers/auth.dart';
import '../../../main.dart';
import '../../configuration/themes.dart';

class DrawerDesign extends StatelessWidget {
  const DrawerDesign({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 100,
          ),
          Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              const Text('Switch Color Mode '),
              const SizedBox(
                width: 10,
              ),
              DayNightSwitcher(
                isDarkModeEnabled:
                    scaffoldKey.currentContext!.read<Themes>().isDark,
                onStateChanged: (isDarkModeEnabled) {
                  scaffoldKey.currentContext!
                      .read<Themes>()
                      .swithMode(isDarkModeEnabled);
                },
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 24,
              ),
              const Text('Logout'),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.read<Auth>().logout();
                  },
                  icon: const Icon(Icons.logout))
            ],
          )
        ],
      ),
    );
  }
}
