//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         intelligent_image_analysisi_controller.dart
// date         2023-01-24
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        ai图片生成界面的后台控制
//

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/index.dart';
import '../../../dialog/index.dart';
import '../../../utils/index.dart';

class IntelligentImageVariationController {
  ///StatefulWidget刷新方法
  final dynamic Function()? refreshInterface;

  ///构造
  IntelligentImageVariationController({
    this.refreshInterface,
  });

  ///获取图片工具类
  final ImagePicker _picker = ImagePicker();

  ///聊天信息列表ScrollController控制器
  final ScrollController scrollController = ScrollController();

  ///请求时是否显示loading
  bool showLoading = false;

  ///图片地址列表
  List<String> imageUrlList = [];

  ///缓存图片资源
  String imageMessage = "image is null";

  ///缓存图片资源
  String? imagePath;

  ///开始请求
  Future<void> requestQustion(BuildContext context) async {
    if (imagePath == null) {
      Toast.bottom('您未选择图片');
      return;
    } else {
      showLoading = true;
      await refreshInterface?.call();
      String result = '';
      try {
        final imageData = await MultipartFile.fromFile(
          imagePath!,
          filename: imagePath,
        );
        final formdata = FormData.fromMap(
          {
            //  The image to use as the basis for the variation(s).
            //Must be a valid PNG file, less than 4MB, and square.
            "image": imageData,
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
        var res = await DioUtil.post(
          url: "/images/variations",
          data: formdata,
          options: Options(
            sendTimeout: LocalKeyValuePair.connectTimeout,
            receiveTimeout: LocalKeyValuePair.receiveTimeout,
            headers: {
              "Authorization": 'Bearer ${LocalKeyValuePair.openAiApiKey}',
            },
            contentType: 'multipart/form-data',
            //返回数据为json
            responseType: ResponseType.json,
            //不管发生错误都返回内容
            validateStatus: (status) => true,
          ),
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

  ///照片尺寸
  double get size => double.parse(LocalKeyValuePair.imageSize.split('x').first);

  ///拍照获取图片
  void getImageFromCamera() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: size,
        maxHeight: size,
        imageQuality: 100,
      );
      generatePng(photo);
    }
  }

  ///从相册中选取图片
  void getImageFromGallery() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: size,
        maxHeight: size,
        imageQuality: 100,
      );
      generatePng(image);
    } else if (Platform.isMacOS) {
      final XFile? file = await openFile(acceptedTypeGroups: [
        const XTypeGroup(
          label: 'images',
          extensions: <String>['jpg', 'png'],
        ),
      ]);
      generatePng(file);
    }
  }

  ///生成图片
  void generatePng(XFile? image) async {
    if (image != null) {
      final imageBytes = await image.readAsBytes();
      final newImage = decodeImage(imageBytes);
      if (newImage != null) {
        final thumbnail = copyResize(
          newImage,
          width: size.toInt(),
          height: size.toInt(),
        );
        final imageWithAlpha = thumbnail.convert(numChannels: 4);
        final data = encodePng(imageWithAlpha);
        final imageName = image.name.substring(
          0,
          image.name.lastIndexOf('.'),
        );
        final path =
            '${(await getTemporaryDirectory()).absolute.path}/$imageName.png';
        File file = File(path);
        if (await file.exists()) {
          await file.delete(recursive: true);
        }
        await file.create(recursive: true);
        await file.writeAsBytes(data);

        imageMessage = '$imageName.png';
        imagePath = file.path;
      }
    } else {
      imagePath = "image is null";
    }
    await refreshInterface?.call();
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
