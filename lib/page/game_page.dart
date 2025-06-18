import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/model/game.dart';
import 'package:speedy_poker/model/player.dart';
import 'package:speedy_poker/model/socket.dart';
import 'package:speedy_poker/widgets/hand.dart';
import 'package:speedy_poker/widgets/pile.dart';

class SpeedyPokerGamePage extends StatefulWidget {
  const SpeedyPokerGamePage({super.key, required this.roomID});

  final int roomID;

  @override
  State<SpeedyPokerGamePage> createState() => _SpeedyPokerGamePageState();
}

class _SpeedyPokerGamePageState extends State<SpeedyPokerGamePage> {
  late SocketService socketService;
  late Game game;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safe to use context here — it's called after initState and context is valid
    socketService = Provider.of<SocketService>(context, listen: false);
    game = Provider.of<Game>(context, listen: false);

    // Set up the socket listener only once
    socketService.emit('getGameState', game.roomID);
    socketService.socket.on('receiveGameState', _handleReceiveGameState);
  }

  void _handleReceiveGameState(dynamic data) {
    if (!mounted) return; // Guard: don't do anything if the widget is disposed
    final gameState = data as Map<String, dynamic>;
    game.updateFromGameState(gameState);
  }

  @override
  void dispose() {
    // Clean up socket listener to prevent memory leaks
    socketService.socket.off('receiveGameState', _handleReceiveGameState);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(
      builder: (context, game, child) {
        final String? mySocketId = socketService.socket.id;

        final Player localPlayer;
        final Player opponentPlayer;

        if (game.player1.socketID == mySocketId) {
          localPlayer = game.player1;
          opponentPlayer = game.player2;
        } else {
          localPlayer = game.player2;
          opponentPlayer = game.player1;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Hand(
              hand: opponentPlayer.hand,
              drawPile: opponentPlayer.hand,
              padding: 10,
              isFlipped: true,
              onTap: (int cardNumber) {},
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
              hand: localPlayer.hand,
              drawPile: localPlayer.drawPile,
              padding: 10,
              isFlipped: false,
              onTap: (int cardNumber) {
                final socketService = Provider.of<SocketService>(
                  context,
                  listen: false,
                );

                socketService.emit('playCard', {
                  cardNumber,
                  game.roomID,
                  localPlayer.toJson(),
                });
              },
            ),
          ],
        );
      },
    );
  }
}
