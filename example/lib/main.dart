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
  bool hasSubSreen = false;
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
                if (routeSettings.name == 'viceMain') {
                  hasSubSreen = true;
                  switch (routeSettings.name) {
                    case SubHome.routeName:
                    default:
                      return const SubHome();
                  }
                } else {
                  switch (routeSettings.name) {
                    case MainHome.routeName:
                    default:
                      return hasSubSreen ? const MainHome() : const LCDHome();
                  }
                }
              });
        });
  }
}
