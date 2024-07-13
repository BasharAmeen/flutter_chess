import 'dart:async';

import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';

import '../../logic/models/pawn.dart';
import '../../logic/models/queen.dart';
import '../../logic/providers/auth.dart';
import '../../logic/models/bishop.dart';

import '../../logic/models/piece.dart';
import '../../logic/models/rook.dart';

import '../../logic/providers/online_game_controller.dart';
import '../../logic/providers/social_provider.dart';
import '../../main.dart';
import '../configuration/responsive.dart';
import '../widgets/home_widgets/custom_button.dart';
import '../widgets/home_widgets/drawer.dart';
import '../widgets/home_widgets/friends_widget.dart';
import '../widgets/home_widgets/profile.dart';
import '../widgets/home_widgets/request_friends_widget.dart';
import '../widgets/home_widgets/search_widget.dart';

import 'game_screen.dart';
import 'signing/loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

TabController? tabController;

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late Stream<DatabaseEvent> challengesStream;

  @override
  void dispose() {
    print('dispose');
    super.dispose();
  }

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3);
    init();
    super.initState();
  }

  void init() {
    var ctx = scaffoldKey.currentContext!;
    var onlineProvider = ctx.read<OnlineGameController>();
    var email = ctx.read<Auth>().accountEmail!.split('@')[0];

    ctx.read<Social>().updateFullAllUserData();

    challengesStream =
        FirebaseDatabase.instance.ref('users/$email/challenges').onValue;
    // This boolean will ensure that there are not to dialog Over some
    bool isDialogShowen = false;
    challengesStream.listen((event) async {
      if (isDialogShowen) {
        Navigator.of(ctx).pop();
      }

      if (!event.snapshot.exists) {
        return;
      }
      Map? data = event.snapshot.value as Map;

      String gameId = data['gameId'];
      String enemyName = data['name'];
      String enemyEmail = data['email'];
      data = null;
      isDialogShowen = true;
      await showDialog(
        barrierDismissible: false,
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Text(
              enemyName,
              style: const TextStyle(color: Colors.amber),
            ),
            content: const Text('challenges you on chess'),
            actions: [
              OutlinedButton(
                onPressed: () async {
                  isDialogShowen = false;
                  onlineProvider.ignoreChallenge(gameId: gameId, email: email);

                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Ignore',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                onPressed: () async {
                  isDialogShowen = false;

                  Navigator.of(ctx).pushReplacement(MaterialPageRoute(
                    builder: (_) => const SplashScreen(),
                  ));
                  onlineProvider
                      .acceptChallenge(
                          gameId: gameId,
                          enemyName: enemyName,
                          enemyEmail: enemyEmail)
                      .then((value) async {
                    await Navigator.of(ctx).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const GameScreen(),
                      ),
                    );
                  });
                },
                child: const Text(
                  'Play',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          );
        },
      );
      isDialogShowen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 16;
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top -
        25;
    print("screenWidth:$screenWidth \n screenHeight: $screenHeight");

    var isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const DrawerDesign(),
      backgroundColor: const Color.fromARGB(180, 67, 65, 65),
      appBar: appBar(screenWidth),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            if (isDesktop)
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: modelSheet(
                    isDrawer: true,
                  ),
                ),
              ),
            Expanded(
              flex: 5,
              child: Container(
                padding: isDesktop
                    ? const EdgeInsets.fromLTRB(16, 8, 40, 8)
                    : const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    if (isDesktop)
                      const Center(
                        child: Text(
                          'Home',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    if (isDesktop)
                      const SizedBox(
                        height: 32,
                      ),
                    Profile(
                        name: context.read<Auth>().accountName!,
                        image: const AssetImage(
                          'assets/Images/profile.jpg',
                        ),
                        level: 15),
                    SizedBox(height: screenHeight / 14.63),
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                            color: Colors.black,
                            width: 1,
                          )),
                          child: Column(
                              children: List.generate(
                                  11,
                                  (index) => rowMaker(
                                      (screenWidth - 2) -
                                          (Responsive.isDesktop(context)
                                              ? (screenWidth / 8 * 3) + 46
                                              : 0),
                                      screenHeight - 20,
                                      index + 1,
                                      ordered: (index + 1) % 2 == 0
                                          ? true
                                          : false))),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(top: screenHeight / 6.584),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black54,
                                  Colors.black45,
                                  Colors.black87,
                                ],
                              ),
                              border: Border.all(
                                color: Colors.black,
                                width: 1.3,
                              ),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            width: screenWidth / 1.977,
                            height: screenHeight / 2.633,
                            child: FittedBox(
                              child: Column(
                                children: [
                                  CustomButton(
                                    text: "Play Online",
                                    screen: null,
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  CustomButton(
                                    text: 'Play Offline',
                                    screen: const GameScreen(),
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                  ),
                                  SizedBox(
                                    height: screenHeight / 65.84285714285714,
                                  ),
                                  CustomButton(
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                    text: 'Saved games',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(double screenWidth) {
    return AppBar(
        title: !Responsive.isDesktop(context)
            ? const Text(
                'Home',
                style: TextStyle(color: Colors.white),
              )
            : null,
        centerTitle: true,
        backgroundColor: Theme.of(context).canvasColor,
        shadowColor: Colors.transparent,
        actions: !Responsive.isDesktop(context)
            ? [
                IconButton(
                  splashRadius: 27,
                  splashColor: Colors.black38,
                  icon: const Icon(
                    Icons.person,
                  ),
                  onPressed: () {
                    modelSheet();
                  },
                ),
                const SizedBox(
                  width: 8,
                )
              ]
            : []);
  }
}

modelSheet({bool? isDrawer}) {
  List<Widget> views = [
    const FriendsWidget(),
    const RequestFriendsWidget(),
    const SearchWidget()
  ];
  return isDrawer != null
      ? Container(
          decoration: const BoxDecoration(
              border: Border(
            right: BorderSide(color: Colors.black),
          )),
          child: Drawer(
            child: DefaultTabControllerWidget(
                tabController: tabController!, views: views),
          ),
        )
      : showDialog(
          context: scaffoldKey.currentContext!,
          builder: (context) => DefaultTabControllerWidget(
              tabController: tabController!, views: views),
        );
}

class DefaultTabControllerWidget extends StatelessWidget {
  const DefaultTabControllerWidget({
    Key? key,
    required this.tabController,
    required this.views,
  }) : super(key: key);

  final TabController tabController;
  final List<Widget> views;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          bottom: TabBar(
            controller: tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(fontStyle: FontStyle.italic),
            tabs: [
              const Text(
                'Friends',
                style: TextStyle(fontSize: 17),
              ),
              Row(
                children: const [Text('Friend requests')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Search',
                    style: TextStyle(fontSize: 17),
                  ),
                  Icon(Icons.search),
                ],
              ),
            ],
          ),
          title: const Center(child: Text('Social')),
        ),
        body: TabBarView(
          controller: tabController,
          physics: const BouncingScrollPhysics(),
          dragStartBehavior: DragStartBehavior.down,
          children: views,
        ),
      ),
    );
  }
}

Row rowMaker(double screenWidth, double screenHeight, index,
    {required bool ordered}) {
  return Row(
      children: List.generate(
          8,
          (index) => square(screenWidth,
              index: ordered ? 1 + index : 8 - index, rowIndex: index)));
}

Widget square(double screenWidth, {required int index, required int rowIndex}) {
  var rand = Random();
  return Container(
    width: screenWidth / 8,
    height: screenWidth / 8,
    color: index % 2 == 0
        ? const Color(0xffbebebe).withOpacity(0.2)
        : const Color(0xff242424).withOpacity(0.2),
    child: rand.nextBool()
        ? pieceIconWidget(rand, rowIndex, index, screenWidth)
        : const Text(''),
  );
}

Widget pieceIconWidget(Random rand, rowIndex, index, double screenWidth) {
  int val = rand.nextInt(6) + 1;
  Piece piece = Rook(
      xAxis: index,
      yAxis: rowIndex,
      color: val % 2 == 0 ? Colors.black : Colors.white);
  switch (val) {
    case 1:
      piece = Rook(
          xAxis: index,
          yAxis: rowIndex,
          color: val % 2 == 0 ? Colors.black : Colors.white);
      break;
    case 2:
      piece = Bishop(
          xAxis: index,
          yAxis: rowIndex,
          color: val % 2 == 0 ? Colors.black : Colors.white);
      break;
    case 3:
      piece = Queen(
          xAxis: index,
          yAxis: rowIndex,
          color: val % 2 == 0 ? Colors.black : Colors.white);
      break;
    case 4:
      piece = Pawn(
          xAxis: index,
          yAxis: rowIndex,
          color: val % 2 == 0 ? Colors.black : Colors.white);
      break;
  }
  // screenBoard[rowIndex][index];

  return Icon(
    piece is Rook
        ? FontAwesome5.chess_rook
        : piece is Bishop
            ? FontAwesome5.chess_bishop
            : piece is Queen
                ? FontAwesome5.chess_queen
                : piece is Pawn
                    ? FontAwesome5.chess_pawn
                    : FontAwesome5.chess_knight,
    color: piece.color,
    size: screenWidth / 20,
  );
}
