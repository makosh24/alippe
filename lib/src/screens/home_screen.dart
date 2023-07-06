import 'package:flutter/material.dart';
import 'AlphabetsScreen/alphabets_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AlphabetsScreen(),
    );
  }
}
