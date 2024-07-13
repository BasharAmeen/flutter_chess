import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../../../logic/providers/auth.dart';
import '../../../logic/providers/online_game_controller.dart';
import '../../../logic/providers/social_provider.dart';
import 'profile.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late List users = [];

  @override
  Widget build(BuildContext context) {
    List<String> allUsers = context.read<Social>().allUsersget;
    Map fullAllUserData = context.read<Social>().allUserFullData;
    double screenWidth = MediaQuery.of(context).size.width;
    Offset tapXY = const Offset(0, 0);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        child: Column(children: [
          SizedBox(
            width: screenWidth - 40,
            child: TextField(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  shadows: [
                    Shadow(
                      blurRadius: 7,
                      color: Colors.white30,
                    ),
                  ],
                ),
                onChanged: (value) {
                  value = value.toLowerCase();
                  value = value.trim();

                  users.clear();
                  if (value.isEmpty) {
                    setState(() {
                      users;
                    });
                    return;
                  }
                  for (var element in allUsers) {
                    if (value.isEmpty) {
                      break;
                    }
                    if (element.toLowerCase().contains(value)) {
                      users.add(element);
                    }
                  }
                  setState(() {
                    users;
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: const BorderSide(width: 1.3),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  contentPadding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Name || ID',
                  hintStyle: const TextStyle(
                    color: Colors.white70,
                    letterSpacing: 0,
                  ),
                  prefixIconColor: Colors.red,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.green,
                  ),
                )),
          ),
          const SizedBox(
            height: 16,
          ),
          const Center(
              child: Text(
            'Results',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
          SizedBox(
            width: screenWidth - 40,
            height: 32,
            child: const Divider(
              color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: List.generate(
                users.length,
                (index) {
                  return GestureDetector(
                    onTapDown: (details) => tapXY = details.globalPosition,
                    onTap: () {
                      showMenu(
                          context: context,
                          constraints: const BoxConstraints(
                            maxWidth: 150,
                          ),
                          position: RelativeRect.fromSize(
                              tapXY & const Size(40, 40),
                              const Size(double.infinity, double.infinity)),
                          items: [
                            const PopupMenuItem(
                              value: 1,
                              child: Text("Profile"),
                            ),
                            PopupMenuItem(
                              onTap: () async {
                                String email = "";
                                List keys = fullAllUserData.keys.toList();
                                List values = fullAllUserData.values.toList();
                                for (int i = 0;
                                    i < fullAllUserData.length;
                                    i++) {
                                  if (values[i]['userName'] == users[index]) {
                                    email = keys[i];

                                    break;
                                  }
                                }
                                String myEmail = context
                                    .read<Auth>()
                                    .accountEmail!
                                    .split('@')[0];
                                await http.put(
                                    Uri.parse(
                                        'https://chess-d1226-default-rtdb.firebaseio.com/users/$email/friendsRequest/$myEmail.json'),
                                    body: json.encode(
                                        context.read<Auth>().accountName!));
                                showToastWidget(
                                  containerOfToast(
                                      child: Text('Request Sent',
                                          style: TextStyle(
                                            color: Colors.green[300],
                                            fontSize: 20,
                                          ),
                                          textAlign: TextAlign.center)),
                                  context: context,
                                );
                              },
                              value: 2,
                              child: Row(
                                children: const [
                                  Text(
                                    "Add friend   ",
                                    style: TextStyle(
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.person_add_rounded),
                                ],
                              ),
                            ),
                          ]);
                    },
                    child: Profile(
                        isFriend: true,
                        name: users[index],
                        image: const AssetImage('images/app_icon.webp'),
                        level: 10),
                  );
                },
              ),
            ),
          )
        ]),
      ),
    );
  }
}
