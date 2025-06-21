import 'package:flutter/material.dart';
import 'package:speedy_poker/constants.dart';
import 'package:speedy_poker/logic/encoding_conversion.dart';

class Card extends StatelessWidget {
  final int cardNumber;
  final double padding;
  final bool isFlipped;
  final Function(int) onTap;
  final GlobalKey? uniqueKey;
  final bool useExpanded; // NEW PARAM

  const Card({
    super.key,
    required this.cardNumber,
    required this.padding,
    required this.isFlipped,
    required this.onTap,
    this.uniqueKey,
    this.useExpanded = true, // default to true
  });

  @override
  Widget build(BuildContext context) {
    final cardWidget = Padding(
      padding: EdgeInsets.all(padding),
      child: Material(
        child: GestureDetector(
          onTap: () => onTap(cardNumber),
          child: isFlipped
              ? FittedBox(
                  fit: BoxFit.contain,
                  child: Image(
                    image: AssetImage(cardBackSVGPath),
                    key: uniqueKey,
                  ),
                )
              : FittedBox(
                  fit: BoxFit.contain,
                  child: Image(
                    image: AssetImage(createCardSVGPath(cardNumber)),
                    key: uniqueKey,
                  ),
                ),
        ),
      ),
    );

    // Use Expanded only if desired
    return useExpanded ? Expanded(child: cardWidget) : cardWidget;
  }
}
