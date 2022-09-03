// import 'package:alippe/src/screens/extract_arguments_screen.dart';
// import 'package:alippe/src/screens/screen_arguments.dart';
import 'package:flutter/material.dart';

// import 'alphabets.dart';
import 'alphabets_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.yellowAccent,
      //   titleTextStyle: const TextStyle(
      //     color: Colors.black,
      //     fontSize: 24,
      //     fontWeight: FontWeight.bold,
      //   ),
      //   shadowColor: Colors.greenAccent,
      //   title: const Text('Әліппе'),
      // ),
      body: AlphabetsScreen(),
    );
  }
}
