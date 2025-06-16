import 'package:flutter/material.dart';
import 'package:speedy_poker/constants.dart';
import 'package:speedy_poker/logic/encoding_conversion.dart';

class Card extends StatelessWidget {
  final int cardNumber;
  final double padding;
  final bool isFlipped;

  const Card({
    super.key,
    required this.cardNumber,
    required this.padding,
    required this.isFlipped,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: isFlipped
            ? FittedBox(
              fit: BoxFit.contain,
              child: Image(image: AssetImage(cardBackSVGPath)),
            )
            : FittedBox(
              fit: BoxFit.contain,
              child: Image(image: AssetImage(createCardSVGPath(cardNumber))),
            )
      ),
    );
  }
}
