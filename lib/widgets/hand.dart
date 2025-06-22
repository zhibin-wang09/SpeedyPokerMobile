import 'package:flutter/material.dart';
import 'package:speedy_poker/widgets/card.dart' as player_card;
import 'package:speedy_poker/widgets/pile.dart';

class Hand extends StatelessWidget {
  final List<int> hand;
  final List<int> drawPile;
  final double padding;
  final bool isFlipped;
  final Function(int) onTap;
  final List<GlobalKey> keys;

  const Hand({
    super.key,
    required this.hand,
    required this.drawPile,
    required this.padding,
    required this.isFlipped,
    required this.onTap,
    required this.keys,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children:
          List.generate(hand.length, (index) {
            return player_card.Card(
                  cardNumber: hand[index],
                  padding: padding,
                  isFlipped: isFlipped,
                  onTap: onTap,
                  uniqueKey: keys[index],
                )
                as Widget;
          }) +
          [
            Pile(
              cards: drawPile,
              padding: padding,
              isFlipped: true,
              uniqueKey: keys[4],
            ),
          ],
    );
  }
}
