//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         my_page_view.dart
// date         2023-01-18
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        对话聊天界面
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/index.dart';
import '../../../model/chat_model.dart';
import '../controller/chatgpt_page_controller.dart';

class ChatgptPageView extends StatefulWidget {
  const ChatgptPageView({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatgptPageView> createState() => _ChatgptPageViewState();
}

class _ChatgptPageViewState extends State<ChatgptPageView> {
  late ChatgptPageController controller = ChatgptPageController(
    refreshInterface: () => setState(() {}),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          buildChatContext(context),
          buildInput(context),
        ],
      ),
    );
  }

  ///页面的appbar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const FittedBox(
        fit: BoxFit.fitWidth,
        child: Text("ChatGpt"),
      ),
      actions: [
        IconButton(
          onPressed: () => controller.showHelp(context),
          icon: const Icon(Icons.help),
        ),
      ],
    );
  }

  ///用户输入
  Widget buildInput(BuildContext context) {
    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width,
      maxHeight: 200.0 + MediaQuery.of(context).padding.bottom,
      child: Container(
        color: const Color.fromARGB(255, 246, 246, 246),
        padding: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 3.0,
          bottom: 5.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                autofocus: true,
                maxLines: null,
                decoration: const InputDecoration(),
                controller: controller.textEditingController,
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: controller.requestQustion,
              child: const Text("发送"),
            ),
          ],
        ),
      ),
    );
  }

  ///机器对话输出
  Widget buildChatContext(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 237, 237, 237),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: controller.messageList.isNotEmpty
              ? ListView(
                  controller: controller.scrollController,
                  children: controller.messageList
                      .map(
                        (value) => buildMessage(
                          context: context,
                          chatModel: value,
                        ),
                      )
                      .toList(),
                )
              : const Align(
                  alignment: Alignment.topCenter,
                  child: Text('让我们开始聊天吧~'),
                ),
        ),
      ),
    );
  }

  ///单条信息
  Widget buildMessage({
    required BuildContext context,
    required ChatModel chatModel,
  }) {
    final isUser = chatModel.user == User.user;
    final userAvator = Icon(
      isUser ? CupertinoIcons.person : Icons.face,
      size: 30.0,
    );
    final message = Card(
      color: isUser ? const Color.fromARGB(255, 169, 234, 122) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 10.0,
        ),
        child: LimitedBox(
          maxWidth: MediaQuery.of(context).size.width * 2 / 3,
          child: SelectableText(
            chatModel.message,
            maxLines: null,
          ),
        ),
      ),
    );
    final nowTime = DateTime.now();
    String text = '';
    if (!(chatModel.dateTime.year == nowTime.year &&
        chatModel.dateTime.month == nowTime.month &&
        chatModel.dateTime.day == nowTime.day)) {
      text += "${chatModel.dateTime.year.toString().padLeft(4, '0')}年"
          "${chatModel.dateTime.month.toString().padLeft(2, '0')}月"
          "${chatModel.dateTime.day.toString().padLeft(2, '0')}日"
          "    ";
    }
    text += "${chatModel.dateTime.hour.toString().padLeft(2, '0')}"
        ":"
        "${chatModel.dateTime.minute.toString().padLeft(2, '0')}"
        ":"
        "${chatModel.dateTime.second.toString().padLeft(2, '0')}";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        text.isNotEmpty ? Text(text) : const SizedBox(),
        Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isUser ? message : userAvator,
                isUser ? userAvator : message,
              ],
            ),
          ],
        )
      ],
    );
  }
}
