import 'package:flutter/material.dart';

class CCard extends StatelessWidget {
  final String letter;
  final String smallLetter;
  final Color color;
  final bool filled;
  final void Function()? callback;

  const CCard({
    Key? key,
    required this.letter,
    required this.smallLetter,
    required this.color,
    this.filled = true,
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
          color: filled ? Colors.black12 : Colors.transparent,
          child: InkWell(
            onTap: callback,
            child: Text(
              '$letter$smallLetter',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 70,
                color: color,
                shadows: filled
                    ? null
                    : const [
                        Shadow(color: Colors.white, blurRadius: 14),
                        Shadow(
                          color: Color(0xAA000000),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
