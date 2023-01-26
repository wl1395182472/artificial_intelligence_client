//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         local_key_value_pair.dart
// date         2023-01-24
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        本地存储键值对
//

import 'dart:ui';

import 'index.dart';

class LocalKeyValuePair {
  ///用户的open api key
  static String _openAiApiKey = HiveUtil.get('openAiApiKey') ?? "";
  static String get openAiApiKey => _openAiApiKey;
  static set openAiApiKey(String value) {
    _openAiApiKey = value;
    HiveUtil.set(key: 'openAiApiKey', value: value);
  }

  ///打开url超时（毫秒）
  static int _connectTimeout = HiveUtil.get('connectTimeout') ?? 5000;
  static int get connectTimeout => _connectTimeout;
  static set connectTimeout(int value) {
    _connectTimeout = value;
    HiveUtil.set(key: 'connectTimeout', value: value);
  }

  ///每当来自响应流的两个事件之间超过[receiveTimeout]（以毫秒为单位）时
  ///
  ///[Dio]将抛出[DioErrorType.REIVE_TIMEOUT]的[DioError]
  ///
  ///注意：这不是接收时间限制
  static int _receiveTimeout = HiveUtil.get('receiveTimeout') ?? 10000;
  static int get receiveTimeout => _receiveTimeout;
  static set receiveTimeout(int value) {
    _receiveTimeout = value;
    HiveUtil.set(key: 'receiveTimeout', value: value);
  }

  ///图片大小
  static String _imageSize = HiveUtil.get('imageSize') ?? "256x256";
  static String get imageSize => _imageSize;
  static set imageSize(String value) {
    _imageSize = value;
    HiveUtil.set(key: 'imageSize', value: value);
  }

  ///图片数量
  static int _imageCounts = HiveUtil.get('imageCounts') ?? 10;
  static int get imageCounts => _imageCounts;
  static set imageCounts(int value) {
    _imageCounts = value;
    HiveUtil.set(key: 'imageCounts', value: value);
  }

  ///显示图片的质量
  static FilterQuality _imageShowQuality = FilterQuality
      .values[HiveUtil.get('imageShowQuality') ?? FilterQuality.high.index];
  static FilterQuality get imageShowQuality => _imageShowQuality;
  static set imageShowQuality(FilterQuality value) {
    _imageShowQuality = value;
    HiveUtil.set(key: 'imageShowQuality', value: value.index);
  }

  ///保存图片的质量
  static int _imageSaveQuality = HiveUtil.get('imageSaveQuality') ?? 100;
  static int get imageSaveQuality => _imageSaveQuality;
  static set imageSaveQuality(int value) {
    _imageSaveQuality = value;
    HiveUtil.set(key: 'imageSaveQuality', value: value);
  }
}
