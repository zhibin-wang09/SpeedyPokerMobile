import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/model/game.dart';
import 'package:speedy_poker/widgets/hand.dart';
import 'package:speedy_poker/widgets/pile.dart';

class SpeedyPokerGamePage extends StatefulWidget {
  const SpeedyPokerGamePage({super.key, required this.gameCode});

  final int gameCode;

  @override
  State<SpeedyPokerGamePage> createState() => _SpeedyPokerGamePageState();
}

class _SpeedyPokerGamePageState extends State<SpeedyPokerGamePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(
      builder: (context, game, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Hand(
              hand: game.player1.hand,
              drawPile: game.player1.drawPile,
              padding: 10,
              isFlipped: false,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: TextDirection.ltr,
              children: <Widget>[
                Pile(cards: game.centerDrawPile1, padding: 8, isFlipped: true),
                Pile(cards: game.centerPile1, padding: 8, isFlipped: false),
                Pile(cards: game.centerPile2, padding: 8, isFlipped: false),
                Pile(cards: game.centerDrawPile2, padding: 8, isFlipped: true),
              ],
            ),

            Hand(
              hand: game.player2.hand,
              drawPile: game.player2.drawPile,
              padding: 10,
              isFlipped: false,
            ),
          ],
        );
      },
    );
  }
}
