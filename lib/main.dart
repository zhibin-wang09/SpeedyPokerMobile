import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/page/game_page.dart';
import 'model/game.dart';
import 'model/socket.dart';

void main() {
  SocketService socket = SocketService();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (context) => socket),
        ChangeNotifierProvider<Game>(
          create: (context) => Game(),
        ),
      ],
      child: const SpeedyPokerGamePage(gameCode: 1),
    ),
  );
}
