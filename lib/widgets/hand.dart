import 'package:flutter/material.dart';
import 'package:speedy_poker/widgets/card.dart' as player_card;
import 'package:speedy_poker/widgets/pile.dart';

class Hand extends StatelessWidget {
  final List<int> hand;
  final List<int> drawPile;
  final double padding;
  final bool isFlipped;

  const Hand({
    super.key,
    required this.hand,
    required this.drawPile,
    required this.padding,
    required this.isFlipped,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children:
          <Widget>[
            player_card.Card(cardNumber: hand[0], padding: padding, isFlipped: isFlipped,),
            player_card.Card(cardNumber: hand[1], padding: padding, isFlipped: isFlipped,),
            player_card.Card(cardNumber: hand[2], padding: padding, isFlipped: isFlipped,),
            player_card.Card(cardNumber: hand[3], padding: padding, isFlipped: isFlipped,),
            Pile(cards: drawPile, padding: padding, isFlipped: !isFlipped),
          ]
    );
  }
}
