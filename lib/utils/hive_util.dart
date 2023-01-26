//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         hive_util.dart
// date         2023-01-18
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        本地键值对存储
//

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveUtil {
  ///Hive工具类
  static Box? box;

  ///是否初始化成功
  static bool get isInitSuccess => box != null;

  ///需要在本地初始化
  static void init() async {
    //存储在应用文档的文件夹
    var path = (await getApplicationDocumentsDirectory()).path;
    Hive.init(path);
    box = await Hive.openBox('chatgpt_client');
  }

  ///通过key获取本地存储
  static dynamic get(dynamic key) {
    if (isInitSuccess) {
      return box?.get(key);
    }
  }

  ///通过key存储本地变量
  static void set({
    required dynamic key,
    required dynamic value,
  }) {
    if (isInitSuccess) {
      box?.put(
        key,
        value,
      );
    }
  }
}
