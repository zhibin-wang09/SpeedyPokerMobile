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
  final double points;
  final bool isLocalPlayer;

  const Hand({
    super.key,
    required this.hand,
    required this.drawPile,
    required this.padding,
    required this.isFlipped,
    required this.onTap,
    required this.keys,
    required this.points,
    required this.isLocalPlayer,
  });

  @override
  Widget build(BuildContext context) {
    int handPlaceHolderLen = 4;

    Widget pointAndDrawPileInfo = Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Points: $points',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, // white text
              decoration: TextDecoration.none, // no underline
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Draw Pile: ${drawPile.length}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white, // white text
              decoration: TextDecoration.none, // no underline
            ),
          ),
        ],
      ),
    );

    Widget handRow = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(hand.length, (index) {
          return player_card.Card(
            cardNumber: hand[index],
            padding: padding,
            isFlipped: isFlipped,
            onTap: onTap,
            uniqueKey: keys[index],
          );
        }),

        // Fillers if hand has fewer than 4 cards
        ...List.generate(handPlaceHolderLen - hand.length, (index) {
          int keyIndex = handPlaceHolderLen - (index + 1);
          return Expanded(child: SizedBox(key: keys[keyIndex]));
        }),

        // Draw Pile itself
        Pile(
          cards: drawPile,
          padding: padding,
          isFlipped: true,
          uniqueKey: keys[4],
        ),
      ],
    );

    // Local player: Points info on top; Opponent: Points info on bottom
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: isLocalPlayer
          ? [pointAndDrawPileInfo, handRow]
          : [handRow, pointAndDrawPileInfo],
    );
  }
}
