import 'package:flutter/material.dart';
import 'package:speedy_poker/widgets/card.dart' as player_card;
import 'package:speedy_poker/widgets/pile.dart';

class Hand extends StatelessWidget {
  final List<int> hand;
  final List<int> drawPile;
  final double padding;
  final bool isFlipped;
  final Function(int) onTap;

  const Hand({
    super.key,
    required this.hand,
    required this.drawPile,
    required this.padding,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children:
          hand
              .map(
                (c) =>
                    player_card.Card(
                          cardNumber: c,
                          padding: padding,
                          isFlipped: isFlipped,
                          onTap: onTap,
                        )
                        as Widget,
              )
              .toList() +
          <Widget>[
            Pile(cards: drawPile, padding: padding, isFlipped: true),
          ],
    );
  }
}
