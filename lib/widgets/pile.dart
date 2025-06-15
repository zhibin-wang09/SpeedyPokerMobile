import 'package:flutter/material.dart';
import 'package:speedy_poker/widgets/card.dart' as playingCard;

class Hand extends StatelessWidget {
  final List<int> cards;

  const Hand({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center ,
      children: cards.map((c) => playingCard.Card(cardNumber: c)).toList(),
    );
  }
}
