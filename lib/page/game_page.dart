import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/logic/encoding_conversion.dart';
import 'package:speedy_poker/model/game.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            
          ],
        );
      },
    );
  }
}
