//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         settings.dart
// date         2023-01-18
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        设置的dialog样式
//

import 'package:flutter/material.dart';
import 'package:intelligent_image_analysis/utils/index.dart';

import '../../data/timeout_data.dart';
import '../my_dialog.dart';

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  int _connectTimeout = LocalKeyValuePair.connectTimeout;
  int _receiveTimeout = LocalKeyValuePair.receiveTimeout;
  String _openAiApiKey = LocalKeyValuePair.openAiApiKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildConnectTimeout(),
        buildReceiveTimeout(),
        const Text('OpenAi Api Key'),
        buildOpenAiApiKey(),
      ],
    );
  }

  Widget buildConnectTimeout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('ConnectTimeout'),
        ElevatedButton(
          onPressed: () async {
            final picker = await MyDialog.showCupertinoDataPicker(
              context: context,
              initialItem: connectTimeoutList.indexOf(_connectTimeout),
              dataList: connectTimeoutList,
            );
            if (picker != null) {
              if (picker != _connectTimeout) {
                _connectTimeout = picker;
                LocalKeyValuePair.connectTimeout = picker;
                setState(() {});
              }
            }
          },
          child: Text('$_connectTimeout'),
        ),
      ],
    );
  }

  Widget buildReceiveTimeout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('ReceiveTimeout'),
        ElevatedButton(
          onPressed: () async {
            final picker = await MyDialog.showCupertinoDataPicker(
              context: context,
              initialItem: receiveTimeoutList.indexOf(_receiveTimeout),
              dataList: receiveTimeoutList,
            );
            if (picker != null) {
              if (picker != _connectTimeout) {
                _receiveTimeout = picker;
                LocalKeyValuePair.receiveTimeout = picker;
                setState(() {});
              }
            }
          },
          child: Text('$_receiveTimeout'),
        ),
      ],
    );
  }

  Widget buildOpenAiApiKey() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () async {
            final text = await MyDialog.showCupertinoTextField(
              context: context,
              text: _openAiApiKey,
              title: 'OpenAi Api Key',
              contentMaxHeight: 120.0,
              hintText: '请输入你的OpenAi Api Key',
            );
            if (text != null) {
              if (text != _openAiApiKey) {
                _openAiApiKey = text;
                LocalKeyValuePair.openAiApiKey = text;
                setState(() {});
              }
            }
          },
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: LimitedBox(
              maxWidth: MediaQuery.of(context).size.width * 9 / 20,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  _openAiApiKey.isNotEmpty
                      ? _openAiApiKey
                      : 'Your OpenAi Api Key',
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
