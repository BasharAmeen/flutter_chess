import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../main.dart';

import '../../../logic/providers/role_organizer.dart';
import '../../../logic/providers/timer_controller.dart';
import '../../configuration/themes.dart';

class TimerWidget extends StatefulWidget {
  final double iconSize;
  final double textSize;
  final bool isTop;
  const TimerWidget({
    Key? key,
    required this.iconSize,
    required this.textSize,
    required this.isTop,
    bool? putChat,
  }) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late bool isFirstP;
  late StreamSubscription timerSubscription;
  late StreamSubscription timerSubscription2;
  int count = 0, count2 = 0;
  Stream? stream;
  StreamController? streamController;

  @override
  void initState() {
    var context = scaffoldKey.currentContext!;

    count = 0;
    count2 = 0;
    isFirstP = context.read<RoleOrganizer>().isFirstPlayerRole;
    // reset case
    if (stream != null) {
      streamController!.close();
      if (widget.isTop) {
        timerSubscription.cancel();
      } else {
        timerSubscription2.cancel();
      }
    }
    stream = Stream<int>.periodic(const Duration(seconds: 1), (int count) {
      return count;
    });
    streamController = StreamController.broadcast();

    if (widget.isTop) {
      timerSubscription = stream!.listen((event) {
        streamController!.add(event);
      });
      timerSubscription.onData((data) {
        // Before first move case [Player Two/ Top player]
        if (isFirstP || context.read<RoleOrganizer>().numberOfMoves == 1) {
          count++;
          timerSubscription.pause();
        } else {
          data as int;
          data -= count;

          if (data % 60 == 0) {
            context.read<TimerController>().reAssignPOneSeconds(0);
          } else if (data % 61 == 0) {
            context.read<TimerController>().minusPOneMinutes();
            context.read<TimerController>().reAssignPOneSeconds(59);
          } else {
            if (data == 1) {
              context.read<TimerController>().minusPOneMinutes();
            }
            context.read<TimerController>().reAssignPOneSeconds(60 - data % 60);
          }
        }
      });
    }
    // ================================================
    StreamController streamController2 = StreamController.broadcast();

    if (!widget.isTop) {
      timerSubscription2 = stream!.listen((event) {
        streamController2.add(event);
      });
      timerSubscription2.onData((data) {
        if (!isFirstP || context.read<RoleOrganizer>().numberOfMoves == 0) {
          count2++;
          timerSubscription2.pause();
        } else {
          data as int;
          data -= count2;
          if (data % 60 == 0) {
            context.read<TimerController>().reAssignPTwoSeconds(0);
          } else if (data % 61 == 0) {
            context.read<TimerController>().minusPTwoMinutes();
            context.read<TimerController>().reAssignPTwoSeconds(59);
          } else {
            if (data == 1) {
              context.read<TimerController>().minusPTwoMinutes();
            }
            context.read<TimerController>().reAssignPTwoSeconds(60 - data % 60);
          }
        }
      });
    }

    //============================
    if (!scaffoldKey.currentContext!.read<TimerController>().shouildreset1 &&
        !scaffoldKey.currentContext!.read<TimerController>().shouildreset2) {
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      letterSpacing: 0.5,
      fontWeight: FontWeight.bold,
      fontSize: widget.textSize,
      color: widget.isTop
          ? context.read<TimerController>().pOneMinutes == 0
              ? Colors.red
              : context.read<Themes>().timerText
          : context.read<TimerController>().pTwoMinutes == 0
              ? Colors.red
              : context.read<Themes>().timerText,
    );
    isFirstP = context.watch<RoleOrganizer>().isFirstPlayerRole;
    if (widget.isTop) {
      if (!isFirstP) {
        timerSubscription.resume();
      }
    } else {
      if (isFirstP) {
        timerSubscription2.resume();
      }
    }
    if (context.read<RoleOrganizer>().numberOfMoves == -1) {
      try {
        timerSubscription2.cancel();
      } catch (e) {
        timerSubscription.cancel();
      }
    }
    if (widget.isTop &&
        scaffoldKey.currentContext!.watch<TimerController>().shouildreset1) {
      initState();
      scaffoldKey.currentContext!.read<TimerController>().shouildreset1 = false;
    }
    if (!widget.isTop &&
        scaffoldKey.currentContext!.watch<TimerController>().shouildreset2) {
      initState();
      scaffoldKey.currentContext!.read<TimerController>().shouildreset2 = false;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: widget.textSize * 4.4,
            height: widget.textSize * 1.4,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.watch<Themes>().timerBox,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                      widget.isTop
                          ? ' ${context.read<TimerController>().pOneMinutes < 10 ? '0' : '  '}${context.read<TimerController>().pOneMinutes}: ${context.read<TimerController>().pOneseconds < 10 ? '0' : ''}${context.watch<TimerController>().pOneseconds} '
                          : ' ${context.read<TimerController>().pTwoMinutes < 10 ? '0' : '  '}${context.read<TimerController>().pTwoMinutes}: ${context.read<TimerController>().pTwoseconds < 10 ? '0' : ''}${context.watch<TimerController>().pTwoseconds} ',
                      style: textStyle,
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
