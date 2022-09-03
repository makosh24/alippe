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
    Alphabets(name: "Б", smallName: "б")
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.deepOrangeAccent[100],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                                  Navigator.pushNamed(
                                      context, ExtractArgumentsScreen.routeName,
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
    );
  }
}

class CCard extends StatelessWidget {
  final double width;
  final String letter;
  final String smallLetter;
  void Function()? callback;
  CCard(
      {Key? key,
      required this.width,
      required this.letter,
      required this.smallLetter,
      this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(20.0),
        // height: 100,
        width: width,
        color: Colors.grey[300],
        child: InkWell(
          onTap: callback,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              letter + " " + smallLetter,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ));
  }
}

class CCardSmall extends StatelessWidget {
  const CCardSmall({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      // height: 100,
      width: 20,
      color: Colors.yellow[300],
      child: Text(
        "A",
        textAlign: TextAlign.center,
        // style: TextStyle(fontSize: 40),
      ),
    );
  }
}

Widget _item(String name, IconData icon, void Function()? callback,
    {String? disabled}) {
  return Expanded(
    child: InkWell(
      onTap: callback,
      child: Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.all(
              const Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              CircleAvatar(
                radius: 25,
                backgroundColor:
                    disabled == 'true' ? Colors.black12 : Colors.greenAccent,
                child: Icon(icon, color: Colors.white),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              Text(
                name,
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              // SizedBox(
              //   height: 22,
              // ),
            ],
          )),
    ),
  );
}
