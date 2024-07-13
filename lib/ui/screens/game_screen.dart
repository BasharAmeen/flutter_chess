import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../logic/functions/reset_board.dart';

import '../../logic/providers/chat_provider.dart';
import '../../logic/providers/online_game_controller.dart';
import '../../logic/providers/role_organizer.dart';
import '../../main.dart';
import '../configuration/responsive.dart';
import '../widgets/game_widgets/square.dart';
import '../widgets/game_widgets/timer.dart';
import '../widgets/home_widgets/drawer.dart';
import 'chat_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final GlobalKey key = GlobalKey();

    final isDesktop = Responsive.isDesktop(context);
    var appBar = gameScreenAppBar();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight =
        MediaQuery.of(context).size.height - appBar.preferredSize.height - 25;
    double availableSpcae = screenHeight - screenWidth;
    if (availableSpcae <= 150) {
      screenHeight -= 150;
      availableSpcae = 150;
    }
    var sideSpace =
        screenWidth - screenHeight > 0 ? screenWidth - screenHeight : 0;
    screenWidth -= sideSpace;

    // declaration
    var isOffline = context.read<RoleOrganizer>().playerNumber == null;
    bool check =
        isOffline ? false : context.read<RoleOrganizer>().playerNumber == 2;
    var textSize2 =
        availableSpcae == 150 ? availableSpcae / 8 : availableSpcae / 12;
    return Scaffold(
        endDrawer: const ChatScreen(
          isDesktop: false,
        ),
        onEndDrawerChanged: (isOpened) {
          if (!isOpened) {
            context.read<Chat>().changeThereIsUnreadedMesseges(false);
          }
        },
        resizeToAvoidBottomInset: false,
        appBar: appBar,
        drawer: const DrawerDesign(),
        body: Builder(builder: (context) {
          return WillPopScope(
            onWillPop: () async {
              if (Scaffold.of(context).isEndDrawerOpen) {
                Scaffold.of(context).closeEndDrawer();
                return false;
              }
              return await onWillPop(context);
            },
            child: Row(
              children: [
                if (isDesktop && !isOffline)
                  Padding(
                    padding: EdgeInsets.only(
                        top: availableSpcae / 2,
                        right: 30.w,
                        left: 16.w,
                        bottom: 20.h),
                    child: Container(
                      width: sideSpace / 1.8 >= 140.w ? 100.w : sideSpace / 1.8,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        border: Border(
                          top: BorderSide(color: Colors.black),
                          right: BorderSide(color: Colors.black),
                        ),
                      ),
                      child: const ChatScreen(
                        isDesktop: true,
                      ),
                    ),
                  ),
                Column(
                    verticalDirection:
                        context.read<RoleOrganizer>().playerNumber != null
                            ? context.read<RoleOrganizer>().playerNumber == 1
                                ? VerticalDirection.down
                                : VerticalDirection.up
                            : VerticalDirection.down,
                    children: <Widget>[
                      SizedBox(
                          height: availableSpcae / 2,
                          child: TimerWidget(
                            key: key,
                            iconSize: availableSpcae / 5,
                            textSize: textSize2,
                            isTop: true,
                          )),
                      ...List.generate(
                          8,
                          (i) => RowMaker(
                                ordered: (i + 1) % 2 == 0
                                    ? check
                                        ? false
                                        : true
                                    : check
                                        ? true
                                        : false,
                                rowIndex: 8 - i,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth,
                              )),
                      if (!isDesktop)
                        SizedBox(
                          height: availableSpcae / 2,
                          child: TimerWidget(
                              iconSize: availableSpcae / 5,
                              textSize: textSize2,
                              isTop: false),
                        ),
                      if (isDesktop)
                        SizedBox(
                            height: availableSpcae / 2,
                            child: TimerWidget(
                              iconSize: availableSpcae / 5,
                              textSize: textSize2,
                              isTop: false,
                            ))
                    ]),
              ],
            ),
          );
        }));
  }

  Future<bool> onWillPop(BuildContext context) async {
    bool answer = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Are you sure you want to leave the game?'),
                content: Text(
                  '- You will lose',
                  style: TextStyle(color: Colors.red[200]),
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          answer = true;
                          exitGame();
                          Navigator.of(context).pop();
                        },
                        child: Row(
                          children: [
                            Text(
                              'Exit  ',
                              style: TextStyle(
                                  color: Colors.red[400], fontSize: 18),
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
                          children: [
                            Text(
                              'Stay  ',
                              style: TextStyle(
                                  color: Colors.green[600], fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ]));
    return answer;
  }

  AppBar gameScreenAppBar() {
    return AppBar(
      title: Center(
          child: Text(
        'Chess Game',
        style: Theme.of(scaffoldKey.currentContext!).appBarTheme.titleTextStyle,
      )),
      backgroundColor: const Color(0xff303030),
      elevation: 0,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
          child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () {
                scaffoldKey.currentContext!
                            .read<RoleOrganizer>()
                            .playerNumber !=
                        null
                    ? scaffoldKey.currentContext!
                        .read<OnlineGameController>()
                        .restartGameRequest()
                    : resetGame();
              },
              child: const Icon(Icons.replay)),
        ),
      ],
    );
  }

  void exitGame() {
    scaffoldKey.currentContext!.read<OnlineGameController>().givingUp();
  }
}

class ChatButton extends StatelessWidget {
  const ChatButton({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white24,
      onPressed: Scaffold.of(context).openEndDrawer,
      child: SizedBox(
        width: 30.w,
        height: 30.h,
        child: Icon(
          context.watch<Chat>().thereIsUnreadedMesseges
              ? Icons.mark_chat_unread_outlined
              : Icons.mark_chat_read_outlined,
          color: context.watch<Chat>().thereIsUnreadedMesseges
              ? Colors.red
              : Colors.green,
        ),
      ),
    );
  }
}

class RowMaker extends StatelessWidget {
  const RowMaker({
    Key? key,
    required this.ordered,
    required this.rowIndex,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  final bool ordered;
  final int rowIndex;
  final double screenHeight;
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return SingleChildScrollView(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                8,
                (int index) => Square(
                  index: ordered ? 1 + index : 8 - index,
                  pieceIndex: [rowIndex, index + 1],
                  screenHeight: screenHeight,
                  screenWidth: screenWidth,
                ),
              )),
        );
      },
    );
  }
}
