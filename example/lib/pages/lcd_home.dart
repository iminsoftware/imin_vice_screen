import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:imin_vice_screen/enums.dart';
import 'package:imin_vice_screen/imin_vice_screen.dart';
import 'package:imin_vice_screen/style.dart';

class LCDHome extends StatefulWidget {
  const LCDHome({super.key});
  @override
  State<LCDHome> createState() => _LCDHomeState();
}

class _LCDHomeState extends State<LCDHome> {
  final iminViceScreenPlugin = IminViceScreen();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LCD screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                await iminViceScreenPlugin.sendLCDCommand(LCDCommand.initLCD);
              },
              child: const Text(' INIT LCD Screen'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                await iminViceScreenPlugin.sendLCDCommand(LCDCommand.wakeLCD);
              },
              child: const Text('WAKE LCD Screen'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                await iminViceScreenPlugin.sendLCDCommand(LCDCommand.sleepLCD);
              },
              child: const Text('SLEEP LCD Screen'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                await iminViceScreenPlugin
                    .sendLCDCommand(LCDCommand.cleanScreenLCD);
              },
              child: const Text('CLEAN LCD Screen'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                await iminViceScreenPlugin.sendLCDString('呵呵!');
              },
              child: const Text('Send Single Line String'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                await iminViceScreenPlugin.sendLCDMultiString(
                    contents: ["سعيد بلقائك", "Des", "嗨嗨"], aligns: [0, 1, 2]);
              },
              child: const Text('Send Multi Line String'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                await iminViceScreenPlugin.sendLCDDoubleString(
                    topText: '顶部内容', bottomText: '底部内容');
              },
              child: const Text('Send Double Line String'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () async {
                // Uint8List byte = await readFileBytes('assets/images/logo.png');
                // await iminViceScreenPlugin.sendLCDBitmap(byte);

                // use url
                await iminViceScreenPlugin.sendLCDBitmap(
                    'https://oss-sg.imin.sg/web/iMinPartner2/images/logo.png',
                    pictureStyle: IminPictureStyle(
                      width: 240,
                      height: 320,
                    ));
              },
              child: const Text('Send Bitmap LCD Screen'),
            ),
             const SizedBox(height: 30),
              TextButton(
              onPressed: () async {
                await iminViceScreenPlugin.setTextSize(15);
              },
              child: const Text('Send Text Size'),
            ),
          ],
        ),
      ),
    );
  }
}

// Future<Uint8List> readFileBytes(String path) async {
//   ByteData fileData = await rootBundle.load(path);
//   Uint8List fileUnit8List = fileData.buffer
//       .asUint8List(fileData.offsetInBytes, fileData.lengthInBytes);
//   return fileUnit8List;
// }

// Future<Uint8List> _getImageFromAsset(String iconPath) async {
//   return await readFileBytes(iconPath);
// }
