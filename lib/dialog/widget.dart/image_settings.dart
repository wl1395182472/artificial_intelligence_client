//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         image_settings.dart
// date         2023-01-24
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        图片设置弹窗
//

import 'package:flutter/material.dart';
import 'package:intelligent_image_analysis/data/index.dart';

import '../../utils/index.dart';
import '../my_dialog.dart';

class ImageSettingsDialog extends StatefulWidget {
  const ImageSettingsDialog({super.key});

  @override
  State<ImageSettingsDialog> createState() => _ImageSettingsDialogState();
}

class _ImageSettingsDialogState extends State<ImageSettingsDialog> {
  String _imageSize = LocalKeyValuePair.imageSize;
  int _imageCounts = LocalKeyValuePair.imageCounts;
  FilterQuality _imageShowQuality = LocalKeyValuePair.imageShowQuality;
  int _imageSaveQuality = LocalKeyValuePair.imageSaveQuality;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildImageSize(),
        buildImageCounts(),
        buildImageShowQuality(),
        buildImageSaveQuality(),
      ],
    );
  }

  Widget buildImageSize() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Size'),
        ElevatedButton(
          onPressed: () async {
            final picker = await MyDialog.showCupertinoDataPicker(
              context: context,
              initialItem: imageSizeList.indexOf(_imageSize),
              dataList: imageSizeList,
            );
            if (picker != null) {
              if (picker != _imageSize) {
                _imageSize = picker;
                LocalKeyValuePair.imageSize = picker;
                setState(() {});
              }
            }
          },
          child: Text(_imageSize),
        ),
      ],
    );
  }

  Widget buildImageCounts() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Counts'),
        ElevatedButton(
          onPressed: () async {
            final picker = await MyDialog.showCupertinoDataPicker(
              context: context,
              initialItem: imageCountsList.indexOf(_imageCounts),
              dataList: imageCountsList,
            );
            if (picker != null) {
              if (picker != _imageCounts) {
                _imageCounts = picker;
                LocalKeyValuePair.imageCounts = picker;
                setState(() {});
              }
            }
          },
          child: Text('$_imageCounts'),
        ),
      ],
    );
  }

  Widget buildImageShowQuality() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Show Quality'),
        ElevatedButton(
          onPressed: () async {
            const dataList = FilterQuality.values;
            final picker = await MyDialog.showCupertinoDataPicker(
              context: context,
              initialItem: dataList.indexOf(_imageShowQuality),
              dataList: dataList,
            );
            if (picker != null) {
              if (picker != _imageShowQuality) {
                _imageShowQuality = picker;
                LocalKeyValuePair.imageShowQuality = picker;
                setState(() {});
              }
            }
          },
          child: Text(
              _imageShowQuality.toString().substring("FilterQuality.".length)),
        ),
      ],
    );
  }

  Widget buildImageSaveQuality() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Save Quality'),
        ElevatedButton(
          onPressed: () async {
            final dataList = List.generate(100, (index) => index + 1);
            final picker = await MyDialog.showCupertinoDataPicker(
              context: context,
              initialItem: dataList.indexOf(_imageSaveQuality),
              dataList: dataList,
            );
            if (picker != null) {
              if (picker != _imageSaveQuality) {
                _imageSaveQuality = picker;
                LocalKeyValuePair.imageSaveQuality = picker;
                setState(() {});
              }
            }
          },
          child: Text('$_imageSaveQuality'),
        ),
      ],
    );
  }
}
