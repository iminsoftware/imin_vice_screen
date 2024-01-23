import 'dart:math';

import 'package:flutter/material.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';

class SubHome extends StatefulWidget {
  const SubHome({super.key});
  static const routeName = '/viceMain';
  @override
  State<SubHome> createState() => _SubHomeState();
}

class _SubHomeState extends State<SubHome> {
  final _iminViceScreenPlugin = IminViceScreen();
  String receiveData = 'null';
  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _iminViceScreenPlugin.viceStream.listen((event) {
      setState(() {
        receiveData = event.arguments.toString();
      });
    });
    Future.delayed(const Duration(seconds: 5), sendMsgToMainScreen);
  }

  void sendMsgToMainScreen() {
    final randomData = Random().nextInt(100).toString();
    _iminViceScreenPlugin
        .sendMsgToMainScreen("text", params: {"num": randomData});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('副屏'),
      ),
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('接收到的主屏数据为：$receiveData'),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: sendMsgToMainScreen,
            child: const Text('发送数据给主屏'),
          ),
        ],
      )),
    );
  }
}
