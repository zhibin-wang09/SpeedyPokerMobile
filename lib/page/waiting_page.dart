import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:speedy_poker/model/socket.dart';
import 'package:speedy_poker/page/game_page.dart';

// This widget represent the waiting page of the game, where the player is waiting
// for the second player to join
class SpeedyPokerWaitingPage extends StatelessWidget {
  const SpeedyPokerWaitingPage({super.key, required this.gameCode});

  final int gameCode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.black),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              spacing: 16.0,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Your game code is: $gameCode, wait for another player to join',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                Consumer<SocketService>(
                  builder: (context, socketService, child){
                    socketService.emit('onPlayerReady', gameCode);
                    SocketService().socket.on('startGameSession', (_){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpeedyPokerGamePage(
                            gameCode: gameCode,
                          ),
                        ),
                      );
                    });
                    return CircularProgressIndicator();
                }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
