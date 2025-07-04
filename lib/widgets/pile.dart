import 'package:flutter/material.dart';
import 'package:speedy_poker/widgets/card.dart' as playing_card;

class Pile extends StatelessWidget {
  final List<int> cards;
  final double padding;
  final bool isFlipped;
  final GlobalKey? uniqueKey;

  const Pile({
    super.key,
    required this.cards,
    required this.padding,
    required this.isFlipped,
    this.uniqueKey,
  });

  @override
  Widget build(BuildContext context) {
    return cards.isNotEmpty
        ? playing_card.Card(
            cardNumber: cards[0],
            padding: padding,
            isFlipped: isFlipped,
            onTap: (int cardNumber) {},
            uniqueKey: uniqueKey,
          )
        : Expanded(child: const SizedBox());
  }
}
