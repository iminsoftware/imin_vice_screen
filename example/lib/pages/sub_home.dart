import 'dart:math';

import 'package:flutter/material.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';
import 'package:video_player/video_player.dart';

class SubHome extends StatefulWidget {
  const SubHome({super.key});
  static const routeName = '/viceMain';
  @override
  State<SubHome> createState() => _SubHomeState();
}

class _SubHomeState extends State<SubHome> {
  final _iminViceScreenPlugin = IminViceScreen();
  String receiveData = 'null';
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        "https://img.tukuppt.com/video_show/2405179/00/01/69/5b486eba157fd.mp4"))
      ..initialize().then((value) {
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
    if (!mounted) return;
    _iminViceScreenPlugin.viceStream.listen((event) {
      debugPrint('viceStream: ${event.method}');
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
    return receiveData != 'null'
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Secondary screen'),
            ),
            body: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('The received home screen data is:$receiveData'),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: sendMsgToMainScreen,
                  child: const Text('Send data to the home screen'),
                ),
              ],
            )),
          )
        : Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(
                    width: 100,
                    height: 100,
                    color: Colors.blue,
                  ));
  }
}
