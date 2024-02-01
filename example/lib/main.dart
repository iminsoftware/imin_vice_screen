import 'package:flutter/material.dart';
import 'pages/main_home.dart';
import 'pages/sub_home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (RouteSettings routeSettings) {
          return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                debugPrint('onGenerateRoute: ${routeSettings.name}');
                if (routeSettings.name == 'viceMain') {
                  switch (routeSettings.name) {
                    case SubHome.routeName:
                    default:
                      return const SubHome();
                  }
                } else {
                  switch (routeSettings.name) {
                    case MainHome.routeName:
                    default:
                      return const MainHome();
                  }
                }
              });
        });
  }
}
