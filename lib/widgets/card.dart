import 'package:flutter/material.dart';
import 'package:speedy_poker/constants.dart';
import 'package:speedy_poker/logic/encoding_conversion.dart';

class Card extends StatelessWidget {
  final int cardNumber;
  final double padding;
  final bool isFlipped;
  final Function(int) onTap;

  const Card({
    super.key,
    required this.cardNumber,
    required this.padding,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Hero(
          tag: cardNumber,
          child: Material(
            child: InkWell(
              onTap: () => onTap(cardNumber),
              child: isFlipped
                  ? FittedBox(
                      fit: BoxFit.contain,
                      child: Image(image: AssetImage(cardBackSVGPath)),
                    )
                  : FittedBox(
                      fit: BoxFit.contain,
                      child: Image(
                        image: AssetImage(createCardSVGPath(cardNumber)),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
