import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../../../logic/models/message.dart';
import '../../../logic/providers/online_game_controller.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(
      {super.key,
      required this.isMe,
      required this.message,
      required this.time});
  final bool isMe;
  final String message;
  final DateTime time;
  @override
  Widget build(BuildContext context) {
    Offset tapXY = const Offset(0, 0);

    var borderRadius2 = BorderRadius.only(
      topLeft: isMe
          ? const Radius.circular(20)
          : Message.isChanged
              ? const Radius.circular(0)
              : const Radius.circular(15),
      topRight: !isMe
          ? const Radius.circular(15)
          : Message.isChanged
              ? const Radius.circular(0)
              : const Radius.circular(15),
      bottomLeft: const Radius.circular(15),
      bottomRight: const Radius.circular(15),
    );
    return GestureDetector(
      onLongPress: () => showMenu(
          context: context,
          position: RelativeRect.fromSize(tapXY & const Size(40, 40),
              const Size(double.infinity, double.infinity)),
          items: [
            PopupMenuItem(
              child: const Text('copy'),
              onTap: () {
                FocusScope.of(context).unfocus();
                Clipboard.setData(ClipboardData(text: message));
                showToastWidget(
                    containerOfToast(child: const Text(' Copyed  ')),
                    alignment: Alignment.topCenter,
                    context: context);
              },
            ),
          ]),
      onTapDown: (details) => tapXY = details.globalPosition,
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Padding(
            padding: REdgeInsets.only(
              top: Message.isChanged ? 10 : 4,
            ),
            child: Container(
              // width: 100.w,
              // height: 50,
              padding: REdgeInsets.fromLTRB(10, 8, 0, 8),
              decoration: BoxDecoration(
                borderRadius: borderRadius2,
                color: isMe ? Colors.white38 : Theme.of(context).cardColor,
              ),
              child: Center(
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 200),
                      child: Text(
                        message,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 23.h,
                        ),
                        const SizedBox(width: 50),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            formatDate(
                              time,
                              [hh, ':', nn],
                            ),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.white54),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
