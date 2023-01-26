//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         home_view.dart
// date         2023-01-24
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        主页界面
//

import 'package:flutter/material.dart';

import '../controller/home_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: buildAppBar(context),
      body: Column(
        children: [
          buildMenuItem(
            context: context,
            description: 'chatgpt聊天',
            onTap: () {
              controller.onClickToChatgpt(context);
            },
          ),
          buildMenuItem(
            context: context,
            description: '智能图像生成',
            onTap: () {
              controller.onClickToIntelligentImageGenerate(context);
            },
          ),
          buildMenuItem(
            context: context,
            description: '智能图像编辑',
            onTap: () {
              controller.onClickToIntelligentImageEdit(context);
            },
          ),
          buildMenuItem(
            context: context,
            description: '智能图像变化',
            onTap: () {
              controller.onClickToIntelligentImageVariation(context);
            },
          ),
        ],
      ),
    );
  }

  ///页面的appbar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const FittedBox(
        fit: BoxFit.fitWidth,
        child: Text("Artificial intelligence from OpenAi"),
      ),
      actions: [
        IconButton(
          onPressed: () => controller.showHelp(context),
          icon: const Icon(Icons.help),
        ),
        IconButton(
          onPressed: () => controller.showSetting(context),
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  ///菜单项
  Widget buildMenuItem({
    required BuildContext context,
    required String description,
    required void Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5.0,
        vertical: 2.0,
      ),
      child: Card(
        elevation: 5.0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: ElevatedButton(
            onPressed: onTap,
            child: Text(description),
          ),
        ),
      ),
    );
  }
}
