import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../logic/models/message.dart';

import '../../logic/providers/chat_provider.dart';
import '../../logic/providers/online_game_controller.dart';
import '../widgets/chat_widgets/message_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.isDesktop,
  });
  final bool isDesktop;
  @override
  Widget build(BuildContext context) {
    OnlineGameController gameProvider = context.read<OnlineGameController>();

    return Scaffold(
      appBar: AppBar(
        leading: isDesktop
            ? const Text('')
            : InkWell(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back),
              ),
        elevation: 5,
        toolbarHeight: 70.h,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 50,
              height: 62.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage("assets/Images/profile.jpg"),
                    fit: BoxFit.fitHeight),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 200,
              child: Text(
                gameProvider.enemyName,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                  overflow: TextOverflow.clip,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Material(
              child: Column(
            children: [
              MessagesViwer(isDesktop: isDesktop),
              const SizedBox(
                width: double.infinity,
                child: Divider(
                  color: Colors.white12,
                  thickness: 0.1,
                ),
              ),
              const ChatFieldSender()
            ],
          ))),
    );
  }
}

class ChatFieldSender extends StatelessWidget {
  const ChatFieldSender({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isValidMessage = false;
    return SizedBox(
      child: Padding(
        padding:
            EdgeInsets.only(right: 3.w, left: 1.2.w, bottom: 4.h, top: 6.h),
        child: StatefulBuilder(
          builder: (ctx, setState) => Row(
            children: [
              Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                        width: 130.w,
                        child: TextField(
                          onChanged: (value) => setState(
                              () => isValidMessage = value.trim().isNotEmpty),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                          controller: ctx.read<Chat>().textController,
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            contentPadding:
                                const EdgeInsets.fromLTRB(10, 8, 10, 8),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: 'Type a message',
                            hintStyle: const TextStyle(
                              color: Colors.white70,
                              letterSpacing: 0,
                            ),
                          ),
                        )),
                  )),
              InkWell(
                onTap: isValidMessage
                    ? () {
                        context.read<Chat>().sendMessage();
                        setState(() => isValidMessage = false);
                      }
                    : null,
                child: Icon(
                  Icons.send,
                  color: isValidMessage ? Colors.white : Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesViwer extends StatefulWidget {
  final bool isDesktop;
  const MessagesViwer({
    Key? key,
    required this.isDesktop,
  }) : super(key: key);

  @override
  State<MessagesViwer> createState() => _MessagesViwerState();
}

class _MessagesViwerState extends State<MessagesViwer> {
  late ScrollController controller;
  @override
  void initState() {
    controller = ScrollController();
    isDesktop = widget.isDesktop;
    super.initState();
  }

  late final bool isDesktop;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        reverse: context.watch<Chat>().numberOfMesseges > 5 ? true : false,
        child: ListView.builder(
          controller: controller,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: context.watch<Chat>().numberOfMesseges,
          itemBuilder: (BuildContext context, int index) {
            try {
              controller.animateTo(controller.position.maxScrollExtent,
                  curve: Curves.bounceInOut,
                  duration: const Duration(milliseconds: 1));
            } catch (_) {}

            Message message = context.read<Chat>().allMessages[index];
            bool isMe = message.isMe();
            Message.wasMe != null && Message.wasMe == isMe
                ? Message.isChanged = false
                : Message.isChanged = true;
            Message.wasMe = isMe;
            return MessageWidget(
                isMe: isMe, message: message.message, time: message.time);
          },
        ),
      ),
    );
  }
}
