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
      // debugPrint('MainHome event: ${event.method}');
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
          content: const Text('The secondary screen has been detected, and the secondary screen should be set as a persistent window to open the permission. Is it set?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                _iminViceScreenPlugin
                    .checkOverlayPermission()
                    .then((hasPermission) {
                  if (hasPermission != null && !hasPermission) {
                    _iminViceScreenPlugin.requestOverlayPermission();
                  } else {
                    _iminViceScreenPlugin.doubleScreenOpen();
                    Navigator.of(context).pop();
                  }
                });
              },
              child: const Text('Yes'),
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
        title: const Text('Home screen'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('The received secondary screen data are:$receiveData'),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: sendMsgToSubScreen,
              child: const Text('Send data to the secondary screen'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _iminViceScreenPlugin.doubleScreenOpen();
              },
              child: const Text('Enable secondary screen'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                await _iminViceScreenPlugin.doubleScreenCancel();
              },
              child: const Text('Close the secondary screen'),
            ),
          ],
        ),
      ),
    );
  }
}
