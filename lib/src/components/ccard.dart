import 'dart:math';

import 'package:flutter/material.dart';

class CCard extends StatefulWidget {
  final double width;
  final double height;
  final String letter;
  final String smallLetter;
  final String soundLetter;
  void Function()? callback;
  CCard(
      {Key? key,
      required this.width,
      required this.height,
      required this.letter,
      required this.smallLetter,
      this.callback,
      required this.soundLetter})
      : super(key: key);

  @override
  State<CCard> createState() => _CCardState();
}

class _CCardState extends State<CCard> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          // padding: const EdgeInsets.all(20.0),
          height: widget.height,
          width: widget.width,
          color: Colors.orange[50],
          child: Center(
            child: InkWell(
              onTap: widget.callback,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  widget.letter + " " + widget.smallLetter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 45,
                      color: Colors.primaries[
                          Random().nextInt(Colors.primaries.length)]),
                ),
              ),
            ),
          )),
    );
  }
}
