//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         intelligent_image_analysisi_controller.dart
// date         2023-01-24
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        ai图片生成界面的后台控制
//

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../../data/index.dart';
import '../../../dialog/index.dart';
import '../../../utils/index.dart';

class IntelligentImageGenerateController {
  ///StatefulWidget刷新方法
  final dynamic Function()? refreshInterface;

  ///构造
  IntelligentImageGenerateController({
    this.refreshInterface,
  });

  ///TextField控制器
  final TextEditingController textEditingController = TextEditingController();

  ///输入框是否显示清除按钮
  bool showClearIcon = false;

  ///聊天信息列表ScrollController控制器
  final ScrollController scrollController = ScrollController();

  ///请求时是否显示loading
  bool showLoading = false;

  ///图片地址列表
  List<String> imageUrlList = [];

  ///开始请求
  Future<void> requestQustion(BuildContext context) async {
    final message = textEditingController.text;
    if (message.isEmpty) {
      Toast.bottom('您未输入任何内容');
      return;
    } else {
      FocusScope.of(context).unfocus();
      showLoading = true;
      await refreshInterface?.call();
      String result = '';
      try {
        var res = await DioUtil.post(
          url: "/images/generations",
          data: {
            //A text description of the desired image(s).
            //The maximum length is 1000 characters.
            "prompt": message,
            //The number of images to generate. Must be between 1 and 10.
            "n": LocalKeyValuePair.imageCounts,
            //The size of the generated images.
            //Must be one of 256x256, 512x512, or 1024x1024.
            "size": LocalKeyValuePair.imageSize,
            //The format in which the generated images are returned.
            //Must be one of url or b64_json.
            "response_format": "url",
          },
        );
        if (kDebugMode) {
          print('res:$res');
        }
        if (res.data != null) {
          final message = res.data["data"];
          final errorMessage =
              res.data['error']?['message']?.toString().trim() ?? '';
          if (message != null) {
            if (res.data["data"] is List) {
              final nowTime = DateTime.now();
              imageUrlList.add("${nowTime.year.toString().padLeft(4, '0')}年"
                  "${nowTime.month.toString().padLeft(2, '0')}月"
                  "${nowTime.day.toString().padLeft(2, '0')}日"
                  "    "
                  "${nowTime.hour.toString().padLeft(2, '0')}"
                  ":"
                  "${nowTime.minute.toString().padLeft(2, '0')}"
                  ":"
                  "${nowTime.second.toString().padLeft(2, '0')}");
              res.data["data"]!.forEach((value) {
                final message = value?["url"];
                if (message != null) {
                  result = message;
                  imageUrlList.add(result);
                }
              });
            } else {
              result = 'imageUrlList is null';
              imageUrlList.add(result);
            }
          } else {
            result = errorMessage;
            imageUrlList.add(result);
          }
        } else {
          result = 'response is null';
          imageUrlList.add(result);
        }
        await refreshInterface?.call();
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
      } finally {
        showLoading = false;
        await refreshInterface?.call();
      }
    }
  }

  ///删除
  void showImageDelete({
    required BuildContext context,
    required String imageUrl,
  }) async {
    await MyDialog.showCupertinoDialog(
      context: context,
      cupertinoAlertDialog: CupertinoAlertDialog(
        title: const Text('是否移除该图片?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              Navigator.of(context).pop();
              imageUrlList.remove(imageUrl);
              await refreshInterface?.call();
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  ///保存
  void showImageSave({
    required BuildContext context,
    required String imageUrl,
  }) async {
    await MyDialog.showCupertinoDialog(
      context: context,
      cupertinoAlertDialog: CupertinoAlertDialog(
        title: const Text('是否保存该图片?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              Navigator.of(context).pop();
              var response = await Dio().get(
                imageUrl,
                options: Options(responseType: ResponseType.bytes),
              );
              final result = await ImageGallerySaver.saveImage(
                Uint8List.fromList(response.data),
                quality: LocalKeyValuePair.imageSaveQuality,
              );
              if (result != null) {
                if (result is Map) {
                  if (result['isSuccess'] != null) {
                    if (result['isSuccess'] is bool) {
                      if (result['isSuccess']) {
                        Toast.bottom('保存成功');
                      } else {
                        Toast.bottom('保存失败');
                      }
                    }
                  }
                }
              }
            },
            child: const Text('确定'),
          ),
        ],
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
          helpDescriptionImageAnaysis,
        ),
      ),
    );
  }

  ///打开设置dialog
  void showSetting(BuildContext context) async {
    await MyDialog.showCupertinoDialog(
      context: context,
      cupertinoAlertDialog: const CupertinoAlertDialog(
        title: Text('Image Settings'),
        content: ImageSettingsDialog(),
      ),
    );
  }
}
