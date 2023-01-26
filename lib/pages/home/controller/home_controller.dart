//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         home_controller.dart
// date         2023-01-24
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        主页界面的后台控制
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/index.dart';
import '../../../dialog/index.dart';
import '../../chatgpt_page/view/chatgpt_page_view.dart';
import '../../intelligent_image_edit/view/intelligent_image_edit_view.dart';
import '../../intelligent_image_generate/view/intelligent_image_generate_view.dart';
import '../../intelligent_image_variation/view/intelligent_image_variation_view.dart';

class HomeController {
  ///构造
  HomeController();

  ///进入Chatgpt聊天页面
  void onClickToChatgpt(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatgptPageView(),
      ),
    );
  }

  ///进入智能图像生成页面
  void onClickToIntelligentImageGenerate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const IntelligentImageGenerateView(),
      ),
    );
  }

  ///进入智能图像编辑页面
  void onClickToIntelligentImageEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const IntelligentImageEditView(),
      ),
    );
  }

  ///进入智能图像变化页面
  void onClickToIntelligentImageVariation(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const IntelligentImageVariationView(),
      ),
    );
  }

  ///打开帮助dialog
  void showHelp(BuildContext context) async {
    await MyDialog.showCupertinoDialog(
      context: context,
      cupertinoAlertDialog: const CupertinoAlertDialog(
        title: Text('Help'),
        content: Text(
          helpDescriptionHome,
        ),
      ),
    );
  }

  ///打开设置dialog
  void showSetting(BuildContext context) async {
    await MyDialog.showCupertinoDialog(
      context: context,
      cupertinoAlertDialog: const CupertinoAlertDialog(
        title: Text('Settings'),
        content: SettingsDialog(),
      ),
    );
  }
}
