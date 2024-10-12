import 'package:flutter/material.dart';
import 'pages/lcd_home.dart';
import 'pages/main_home.dart';
import 'pages/sub_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                // D4 使用的副屏
               if (routeSettings.name == 'viceMain') {
                 return const SubHome();
               } else {
                 return const MainHome();
               } 

               // Falcon 1 使用的迷你副屏
              // return const LCDHome();
              });
        });
  }
}
