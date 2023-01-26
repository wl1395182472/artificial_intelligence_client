//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         my_page_controller.dart
// date         2023-01-18
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        对话聊天界面的后台控制
//

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../../../dialog/index.dart';
import '../../../data/index.dart';
import '../../../model/index.dart';
import '../../../utils/index.dart';

class ChatgptPageController {
  ///StatefulWidget刷新方法
  final dynamic Function()? refreshInterface;

  ///构造
  ChatgptPageController({
    this.refreshInterface,
  });

  ///TextField控制器
  final TextEditingController textEditingController = TextEditingController();

  ///聊天信息列表ScrollController控制器
  final ScrollController scrollController = ScrollController();

  ///聊天信息队列
  List<ChatModel> messageList = [];

  ///开始请求
  Future<void> requestQustion() async {
    final message = textEditingController.text;
    if (message.isEmpty) {
      Toast.bottom('您未输入任何内容');
      return;
    } else {
      //将用户信息加入列表并清空输入框
      messageList.add(ChatModel(
        user: User.user,
        message: message,
      ));
      await refreshInterface?.call();
      Future.delayed(
        const Duration(milliseconds: 200),
        () =>
            scrollController.jumpTo(scrollController.position.maxScrollExtent),
      );
      textEditingController.clear();

      try {
        String result = '';
        var res = await DioUtil.post(
          url: "/completions",
          data: {
            "model": "text-davinci-003",
            "prompt": message,
            "temperature": 1,
            "max_tokens": 1024,
          },
        );
        if (kDebugMode) {
          print('res:$res');
        }
        if (res.data != null) {
          final message = res.data["choices"]?[0]?["text"]?.toString().trim();
          final errorMessage =
              res.data['error']?['message']?.toString().trim() ?? '';
          if (message != null) {
            final start = message.indexOf('\n\n');
            if (start >= 0) {
              result = message.substring(start).trim();
            } else {
              result = message;
            }
          } else {
            result = errorMessage;
          }
        } else {
          result = 'response is null';
        }
        messageList.add(ChatModel(
          user: User.rebot,
          message: result,
        ));
        await refreshInterface?.call();
        Future.delayed(
          const Duration(milliseconds: 200),
          () => scrollController
              .jumpTo(scrollController.position.maxScrollExtent),
        );
      } catch (error, stackTrace) {
        if (kDebugMode) {
          print('post\nerror:$error\nstackTrace:$stackTrace');
        }
        if (error is DioError) {
          if (error.error != null) {
            Toast.bottom(
              error.error.toString(),
              durationSeconds: 5,
            );
          }
        }
      }
    }
  }

  ///打开帮助dialog
  void showHelp(BuildContext context) async {
    await MyDialog.showCupertinoDialog(
      context: context,
      cupertinoAlertDialog: const CupertinoAlertDialog(
        title: Text('Help'),
        content: Text(
          helpDescriptionChatgpt,
        ),
      ),
    );
  }
}
