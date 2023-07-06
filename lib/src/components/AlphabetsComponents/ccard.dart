import 'dart:math';

import 'package:flutter/material.dart';

class CCard extends StatefulWidget {
  // final double height;
  final String letter;
  final String smallLetter;
  final String soundLetter;
  final void Function()? callback;
  const CCard(
      {Key? key,
      // required this.height,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 100, maxWidth: 100),
          alignment: Alignment.center,
          color: Colors.black12,
          child: InkWell(
            onTap: widget.callback,
            child: Text(
              widget.letter + widget.smallLetter,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 70,
                  color: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)]),
            ),
          ),
        ),
      ),
    );
  }
}
