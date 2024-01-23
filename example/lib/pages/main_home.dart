import 'dart:math';

import 'package:flutter/material.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});
  static const routeName = '/main';
  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final _iminViceScreenPlugin = IminViceScreen();
  String receiveData = 'null';

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkOverlayPermission();
    });
    _iminViceScreenPlugin.mainStream.listen((event) {
      debugPrint('MainHome event: ${event.arguments}');
      setState(() {
        receiveData = event.arguments.toString();
      });
    });
  }

  ///判读是否需要 overlay 窗口权限
  Future<void> checkOverlayPermission() async {
    dynamic isMultipleScreen =
        await _iminViceScreenPlugin.isSupportMultipleScreen();
    if (isMultipleScreen != null && isMultipleScreen) {
      dynamic hasOverlayPermission =
          await _iminViceScreenPlugin.checkOverlayPermission();
      debugPrint("是否有 overlay 权限: $hasOverlayPermission");
      if (hasOverlayPermission != null && !hasOverlayPermission) {
        _showCheckOverlayPermission();
      }
    }
  }

  Future<void> _showCheckOverlayPermission() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const Text('已检测到副屏，将副屏设置为持久窗口需开启权限，是否设置'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
              },
              child: const Text('否'),
            ),
            TextButton(
              onPressed: () async {
                final hasPermission = await _iminViceScreenPlugin.checkOverlayPermission();
                if (hasPermission != null && !hasPermission) {
                  _iminViceScreenPlugin.requestOverlayPermission();
                } else {
                  _iminViceScreenPlugin.doubleScreenOpen();
                  // Navigator.of(context).pop();
                }
              },
              child: const Text('是'),
            ),
          ],
        );
      },
    );
  }

  Future<void> sendMsgToSubScreen() async {
    final isMultipleScreen =
        await _iminViceScreenPlugin.isSupportMultipleScreen();
    if (isMultipleScreen != null && isMultipleScreen) {
      final randomData = Random().nextInt(100).toString();
      _iminViceScreenPlugin
          .sendMsgToViceScreen('text', params: {'data': randomData});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('主屏'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('接收到的副屏数据为：$receiveData'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: sendMsgToSubScreen,
              child: const Text('发送数据给副屏'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _iminViceScreenPlugin.doubleScreenOpen();
              },
              child: const Text('开启副屏'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _iminViceScreenPlugin.doubleScreenCancel();
              },
              child: const Text('关闭副屏'),
            ),
          ],
        ),
      ),
    );
  }
}
