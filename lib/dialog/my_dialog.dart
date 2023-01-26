//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         my_dialog.dart
// date         2023-01-18
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        dialog样式
//

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDialog {
  static Future showCupertinoDialog({
    required BuildContext context,
    required CupertinoAlertDialog cupertinoAlertDialog,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      builder: (context) => cupertinoAlertDialog,
    );
  }

  static Future showCupertinoDataPicker({
    required BuildContext context,
    int? initialItem,
    required List dataList,
    ImageFilter? filter,
    Color barrierColor = kCupertinoModalBarrierColor,
    bool barrierDismissible = true,
    bool useRootNavigator = true,
    bool? semanticsDismissible,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) {
    return showCupertinoModalPopup(
      context: context,
      filter: filter,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      semanticsDismissible: semanticsDismissible,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      builder: (BuildContext context) {
        final height = (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom) /
            3;
        final fixedExtentScrollController = FixedExtentScrollController(
          initialItem: initialItem ?? 0,
        );
        return Container(
          height: height,
          color: Theme.of(context).dialogBackgroundColor,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("取消"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(
                        context,
                        dataList[fixedExtentScrollController.selectedItem],
                      );
                    },
                    child: const Text("确认"),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  itemExtent: height / 9,
                  scrollController: fixedExtentScrollController,
                  onSelectedItemChanged: null,
                  children: dataList
                      .map(
                        (value) => Text(
                          '$value',
                          maxLines: null,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future showCupertinoTextField({
    required BuildContext context,
    required String text,
    double? contentMaxHeight,
    String? title,
    String? hintText,
    bool barrierDismissible = true,
    Color? barrierColor = Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    Offset? anchorPoint,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      anchorPoint: anchorPoint,
      builder: (BuildContext context) {
        final textEditingController = TextEditingController(text: text);
        return CupertinoAlertDialog(
          title: title != null
              ? Text(
                  title,
                  maxLines: null,
                )
              : null,
          content: LimitedBox(
            maxHeight: contentMaxHeight ?? 250.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: TextField(
                      controller: textEditingController,
                      autofocus: true,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: hintText,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      textEditingController.text,
                    );
                  },
                  child: const Text("确认"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
