//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         toast.dart
// date         2023-01-19
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        Toast弹窗工具类
//

import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

///提示窗
class Toast {
  static void bottom(
    String message, {
    bool allowClick = true,
    int durationSeconds = 2,
    bool onlyOne = true,
  }) {
    BotToast.showEnhancedWidget(
      duration: Duration(seconds: durationSeconds),
      allowClick: allowClick,
      onlyOne: onlyOne,
      toastBuilder: (closeFunc) => Container(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 100.0,
        ),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5.0,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.black54,
              ),
              child: Text(
                message,
                maxLines: null,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
