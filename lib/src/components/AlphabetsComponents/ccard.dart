import 'package:flutter/material.dart';

class CCard extends StatelessWidget {
  final String letter;
  final String smallLetter;
  final Color color;
  final void Function()? callback;

  const CCard({
    Key? key,
    required this.letter,
    required this.smallLetter,
    required this.color,
    this.callback,
  }) : super(key: key);

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
            onTap: callback,
            child: Text(
              '$letter$smallLetter',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 70,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
