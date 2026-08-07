import 'dart:math';

import 'package:flutter/material.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';
import 'package:video_player/video_player.dart';

class SubHome extends StatefulWidget {
  static const routeName = '/viceMain';
  const SubHome({super.key});
  @override
  State<SubHome> createState() => _SubHomeState();
}

class _SubHomeState extends State<SubHome> with WidgetsBindingObserver {
  final _iminViceScreenPlugin = IminViceScreen();
  String receiveData = 'null';
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"))
      ..setLooping(true)
      ..initialize().then((value) {
        if (!mounted) return;
        // Only start playing if the secondary screen is currently visible;
        // if it was hidden before the network video finished loading, stay paused.
        if (WidgetsBinding.instance.lifecycleState ==
            AppLifecycleState.resumed) {
          _controller.play();
        }
        setState(() {});
      });
    _iminViceScreenPlugin.viceStream.listen((event) {
      debugPrint('viceStream: ${event.method}');
      setState(() {
        receiveData = event.arguments.toString();
      });
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;
    if (state == AppLifecycleState.resumed) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void sendMsgToMainScreen() {
    final randomData = Random().nextInt(100).toString();
    _iminViceScreenPlugin
        .sendMsgToMainScreen("text", params: {"num": randomData});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading video…',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    receiveData != 'null'
                        ? 'Received: $receiveData'
                        : 'Waiting for data…',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: sendMsgToMainScreen,
                    child: const Text('Send to home screen'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
