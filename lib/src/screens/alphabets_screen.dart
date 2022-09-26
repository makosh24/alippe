import 'package:alippe/src/components/ccard.dart';
import 'package:alippe/src/components/ccarssmall.dart';
import 'package:alippe/src/screens/screen_arguments.dart';
import 'package:flutter/material.dart';

import 'alphabets.dart';
import 'extract_arguments_screen.dart';

class AlphabetsScreen extends StatefulWidget {
  const AlphabetsScreen({Key? key}) : super(key: key);

  @override
  State<AlphabetsScreen> createState() => _AlphabetsScreenState();
}

class _AlphabetsScreenState extends State<AlphabetsScreen> {
  List<Alphabets> alphabets = [
    Alphabets(name: "A", smallName: "a"),
    Alphabets(name: "Ә", smallName: "ә"),
    Alphabets(name: "Б", smallName: "б"),
    Alphabets(name: "Ы", smallName: "ы")
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/fantastic.jpeg"),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.deepOrangeAccent[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  const Text(
                    "Әліппе әлеміне қош келдің балақай!!!",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: alphabets
                          .map((letter) => CCard(
                              width: 100,
                              letter: letter.name,
                              smallLetter: letter.smallName,
                              callback: () => {
                                    Navigator.pushNamed(context,
                                        ExtractArgumentsScreen.routeName,
                                        arguments: ScreenArguments(
                                          letter.name,
                                          letter.smallName,
                                        ))
                                  }))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(
            color: Colors.grey,
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 0,
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.deepOrangeAccent[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                    // width: 20,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const <Widget>[
                        CCardSmall(),
                        CCardSmall(),
                        CCardSmall(),
                        CCardSmall(),
                        CCardSmall(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
