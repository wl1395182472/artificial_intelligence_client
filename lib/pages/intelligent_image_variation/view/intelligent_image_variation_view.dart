//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         intelligent_image_analysisi_view.dart
// date         2023-01-24
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        ai图片生成界面
//

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intelligent_image_analysis/utils/index.dart';

import '../controller/intelligent_image_variation_controller.dart';

class IntelligentImageVariationView extends StatefulWidget {
  const IntelligentImageVariationView({super.key});

  @override
  State<IntelligentImageVariationView> createState() =>
      _IntelligentImageVariationViewState();
}

class _IntelligentImageVariationViewState
    extends State<IntelligentImageVariationView> {
  late final IntelligentImageVariationController controller =
      IntelligentImageVariationController(
    refreshInterface: () {
      setState(() {});
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          buildTips(),
          buildImage(context),
          buildInput(context),
        ],
      ),
    );
  }

  ///页面的appbar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const FittedBox(
        fit: BoxFit.fitWidth,
        child: Text("Intelligent Image Variation"),
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

  ///提示
  Widget buildTips() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        '***  单击移除图片  双击保存图片  ***',
        style: TextStyle(
          color: Colors.redAccent,
        ),
      ),
    );
  }

  ///用户输入
  Widget buildInput(BuildContext context) {
    return LimitedBox(
      maxWidth: MediaQuery.of(context).size.width,
      child: Container(
        color: const Color.fromARGB(255, 246, 246, 246),
        padding: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 3.0,
          bottom: 5.0 + MediaQuery.of(context).padding.bottom,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    controller.imageMessage,
                    overflow: TextOverflow.fade,
                  ),
                ),
                ElevatedButton(
                  onPressed: controller.getImageFromCamera,
                  child: const Text('拍照'),
                ),
                const SizedBox(width: 10.0),
                ElevatedButton(
                  onPressed: controller.getImageFromGallery,
                  child: const Text('选择图片'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (controller.showLoading) {
                      return;
                    }
                    controller.requestQustion(context);
                  },
                  child: controller.showLoading
                      ? const CupertinoActivityIndicator()
                      : const Text("生成"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///生成的图片
  Widget buildImage(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          color: const Color.fromARGB(255, 237, 237, 237),
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: controller.imageUrlList.isNotEmpty
              ? ListView(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  controller: controller.scrollController,
                  children: controller.imageUrlList
                      .map(
                        (value) => KeepAliveWrapper(
                          child: buildImageItem(value),
                        ),
                      )
                      .toList(),
                )
              : const Align(
                  alignment: Alignment.topCenter,
                  child: Text('输入关键词生成你想要的图片吧~'),
                ),
        ),
      ),
    );
  }

  ///图片item
  Widget buildImageItem(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller.showImageDelete(
            context: context,
            imageUrl: imageUrl,
          );
        },
        onDoubleTap: () {
          controller.showImageSave(
            context: context,
            imageUrl: imageUrl,
          );
        },
        child: Image.network(
          imageUrl,
          fit: BoxFit.fill,
          filterQuality: LocalKeyValuePair.imageShowQuality,
          loadingBuilder: (context, child, loadingProgress) {
            Future.delayed(
              const Duration(milliseconds: 200),
              () => controller.scrollController
                  .jumpTo(controller.scrollController.position.maxScrollExtent),
            );
            final progress = (loadingProgress != null &&
                    loadingProgress.expectedTotalBytes != null)
                ? (loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!)
                : null;
            return progress == 1 || progress == null
                ? child
                : Row(
                    children: [
                      CircularProgressIndicator(value: progress),
                      const SizedBox(width: 20.0),
                      const Text('加载中...'),
                    ],
                  );
          },
          errorBuilder: (context, error, stackTrace) => Center(
            child: Card(
              child: Text(
                imageUrl,
                maxLines: null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
