import 'package:alippe/src/screens/extract_arguments_screen.dart';
import 'package:alippe/src/screens/home_screen.dart';
import 'package:alippe/src/screens/pass_arguments_screen.dart';
import 'package:alippe/src/screens/screen_arguments.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen()
      },
      onGenerateRoute: (settings) {
        if (settings.name == ExtractArgumentsScreen.routeName) {
          return MaterialPageRoute(
            builder: (context) {
              return ExtractArgumentsScreen();
            },
          );
        } else if (settings.name == PassArgumentsScreen.routeName) {
          final args = settings.arguments as ScreenArguments;

          return MaterialPageRoute(
            builder: (context) {
              return PassArgumentsScreen(
                title: args.title,
                message: args.message,
              );
            },
          );
        }
      },
      title: 'Navigation with Arguments',
      home: const HomeScreen(),
    );
  }
}
