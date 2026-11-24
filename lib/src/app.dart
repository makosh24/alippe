import 'package:alippe/src/parent/parent_session.dart';
import 'package:alippe/src/screens/AlphabetsScreen/alphabets_in_screen.dart';
import 'package:alippe/src/screens/FairyTalesScreen/fairy_tales_screen.dart';
import 'package:alippe/src/screens/home_screen.dart';
import 'package:alippe/src/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ParentSession _session = ParentSession();

  @override
  void dispose() {
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ParentScope(
      session: _session,
      child: MaterialApp(
        routes: {
          AlphabetsInScreen.routeName: (context) => const AlphabetsInScreen(),
          FairyTalesScreen.routeName: (context) => const FairyTalesScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
        },
        title: 'Alippe',
        home: const HomeScreen(),
      ),
    );
  }
}
