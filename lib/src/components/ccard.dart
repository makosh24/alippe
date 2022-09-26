import 'package:flutter/material.dart';

class CCard extends StatefulWidget {
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
  State<CCard> createState() => _CCardState();
}

class _CCardState extends State<CCard> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
          // padding: const EdgeInsets.all(20.0),
          // height: 100,
          width: widget.width,
          color: Colors.grey[300],
          child: Center(
            child: InkWell(
              onTap: widget.callback,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Text(
                  widget.letter + " " + widget.smallLetter,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 45),
                ),
              ),
            ),
          )),
    );
  }
}