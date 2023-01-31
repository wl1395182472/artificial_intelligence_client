//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         main.dart
// date         2023-01-18
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        main执行app启动
//

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_image_analysis/pages/home/view/home_view.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'utils/hive_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HiveUtil.init();
  runApp(
    MaterialApp(
      home: HomeView(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveWrapper.builder(
        BotToastInit()(
          context,
          child,
        ),
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
        background: Container(
          color: const Color(0xFFF5F5F5),
        ),
      ),
    ),
  );
}
