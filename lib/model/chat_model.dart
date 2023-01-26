//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         chat_model.dart
// date         2023-01-18
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        对话类
//

import '../data/index.dart';

class ChatModel {
  final User user;
  final String message;
  late final DateTime dateTime;

  ChatModel({
    required this.user,
    required this.message,
  }) {
    dateTime = DateTime.now();
  }
}
