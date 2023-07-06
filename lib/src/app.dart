import 'package:alippe/src/screens/AlphabetsScreen/alphabets_in_screen.dart';
import 'package:alippe/src/screens/home_screen.dart';
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
        AlphabetsInScreen.routeName: (context) => const AlphabetsInScreen()
      },
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return const AlphabetsInScreen();
          },
        );
      },
      title: 'Navigation with Arguments',
      home: const HomeScreen(),
    );
  }
}
