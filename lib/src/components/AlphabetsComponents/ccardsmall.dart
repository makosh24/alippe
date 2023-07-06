import 'package:flutter/material.dart';

class CCardSmall extends StatelessWidget {
  const CCardSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      // height: 100,
      width: 20,
      color: Colors.yellow[300],
      child: const Text(
        "A",
        textAlign: TextAlign.center,
        // style: TextStyle(fontSize: 40),
      ),
    );
  }
}
