import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/enums/animated_card_type.dart';
import 'package:speedy_poker/enums/destination.dart';
import 'package:speedy_poker/enums/player_id.dart';
import 'package:speedy_poker/model/game.dart';
import 'package:speedy_poker/model/game_response.dart';
import 'package:speedy_poker/model/player.dart';
import 'package:speedy_poker/model/socket.dart';
import 'package:speedy_poker/widgets/hand.dart';
import 'package:speedy_poker/widgets/pile.dart';
import 'package:speedy_poker/widgets/card.dart' as game_card;
import 'package:speedy_poker/model/animate_card.dart';

class SpeedyPokerGamePage extends StatefulWidget {
  const SpeedyPokerGamePage({super.key, required this.roomID});

  final int roomID;

  @override
  State<SpeedyPokerGamePage> createState() => _SpeedyPokerGamePageState();
}

class _SpeedyPokerGamePageState extends State<SpeedyPokerGamePage>
    with TickerProviderStateMixin {
  late SocketService socketService;
  late Game game;

  List<GlobalKey> _opponentPlayerKeys = [];
  List<GlobalKey> _centerPileKeys = [];
  List<GlobalKey> _localPlayerKeys = [];

  final GlobalKey _stackKey = GlobalKey();

  Player _localPlayer = Player();
  Player _opponentPlayer = Player();

  final List<AnimatingCard> _animatingCards = [];

  @override
  void initState() {
    super.initState();
    const bottomRowNumCards = 5;
    const centerPileNumCards = 5;

    _opponentPlayerKeys = List.generate(
      bottomRowNumCards,
      (index) => GlobalKey(),
    );
    _centerPileKeys = List.generate(centerPileNumCards, (index) => GlobalKey());
    _localPlayerKeys = List.generate(bottomRowNumCards, (index) => GlobalKey());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    socketService = Provider.of<SocketService>(context, listen: false);
    game = Provider.of<Game>(context, listen: false);

    socketService.emit('getGameState', game.getRoomID);
    socketService.socket.on('receiveGameState', _handleReceiveGameState);
  }

  void _handleReceiveGameState(dynamic json) {
    if (!mounted || json == null) return;
    final res = UpdatedGameResponse.fromJson(json);

    game.updateFromGameState(res.game);

    final localPlayer = game.getPlayer1.getSocketID == socketService.socket.id
        ? game.getPlayer1
        : game.getPlayer2;

    final opponentPlayer =
        game.getPlayer1.getSocketID == socketService.socket.id
        ? game.getPlayer2
        : game.getPlayer1;

    setState(() {
      _localPlayer = localPlayer;
      _opponentPlayer = opponentPlayer;
    });

    if (res.playerTurn == PlayerID.def) return;

    _startAnimation(res.playerTurn, res.cardIndex, res.destination);
    _startAnimationDrawToHand(res.playerTurn, res.cardIndex, res.newCard);
  }

  void _startAnimation(
    PlayerID playerTurn,
    int playerCardIndex,
    Destination dest,
  ) {
    final selectedCardKey = playerTurn == _localPlayer.getPlayerID
        ? _localPlayerKeys[playerCardIndex]
        : _opponentPlayerKeys[playerCardIndex];

    final targetPileKey = dest.index == Destination.centerPile1.index
        ? _centerPileKeys[2]
        : _centerPileKeys[3];

    _animateCard(selectedCardKey, targetPileKey, playerTurn, playerCardIndex);
  }

  void _startAnimationDrawToHand(
    PlayerID player,
    int targetHandIndex,
    int cardNumber,
  ) {
    final targetHandKey = player == _localPlayer.getPlayerID
        ? _localPlayerKeys[targetHandIndex]
        : _opponentPlayerKeys[targetHandIndex];

    final sourceDrawPileKey = player == _localPlayer.getPlayerID
        ? _localPlayerKeys[4]
        : _opponentPlayerKeys[4];

    _animateCard(
      sourceDrawPileKey,
      targetHandKey,
      player,
      targetHandIndex,
      isDraw: true,
      cardNumber: cardNumber,
    );
  }

  void _animateCard(
    GlobalKey fromKey,
    GlobalKey toKey,
    PlayerID player,
    int cardIndex, {
    bool isDraw = false,
    int? cardNumber,
  }) {
    final fromBox = fromKey.currentContext?.findRenderObject() as RenderBox;
    final toBox = toKey.currentContext?.findRenderObject() as RenderBox;
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox;

    final globalStart = fromBox.localToGlobal(Offset.zero);
    final globalEnd = toBox.localToGlobal(Offset.zero);
    final stackOffset = stackBox.localToGlobal(Offset.zero);

    final localStart = globalStart - stackOffset;
    final localEnd = globalEnd - stackOffset;

    final controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    final animation = Tween<Offset>(
      begin: localStart,
      end: localEnd,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    final animCard = AnimatingCard(
      cardNumber:
          cardNumber ??
          (player == _localPlayer.getPlayerID
              ? _localPlayer.getHand[cardIndex]
              : _opponentPlayer.getHand[cardIndex]),
      animation: animation,
      controller: controller,
      type: isDraw ? AnimateCardType.draw : AnimateCardType.play,
    );

    setState(() => _animatingCards.add(animCard));

    controller.forward().whenComplete(() {
      setState(() => _animatingCards.remove(animCard));
      controller.dispose();
    });
  }

  @override
  void dispose() {
    socketService.socket.off('receiveGameState', _handleReceiveGameState);
    for (var card in _animatingCards) {
      card.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _stackKey,
      children: [
        Consumer<Game>(
          builder: (context, game, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Hand(
                  hand: _opponentPlayer.getHand,
                  drawPile: _opponentPlayer.getDrawPile,
                  padding: 10,
                  isFlipped: true,
                  onTap: (_) {},
                  keys: _opponentPlayerKeys,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Pile(
                      cards: game.getCenterDrawPile1,
                      padding: 8,
                      isFlipped: true,
                      uniqueKey: _centerPileKeys[0],
                    ),
                    Pile(
                      cards: game.getCenterPil1,
                      padding: 8,
                      isFlipped: false,
                      uniqueKey: _centerPileKeys[2],
                    ),
                    Pile(
                      cards: game.getCenterPil2,
                      padding: 8,
                      isFlipped: false,
                      uniqueKey: _centerPileKeys[3],
                    ),
                    Pile(
                      cards: game.getCenterDrawPile2,
                      padding: 8,
                      isFlipped: true,
                      uniqueKey: _centerPileKeys[1],
                    ),
                  ],
                ),
                Hand(
                  hand: _localPlayer.getHand,
                  drawPile: _localPlayer.getDrawPile,
                  padding: 10,
                  isFlipped: false,
                  onTap: (int cardNumber) {
                    socketService.emit('playCard', [
                      cardNumber,
                      game.getRoomID,
                      _localPlayer.toJson(),
                    ]);
                  },
                  keys: _localPlayerKeys,
                ),
              ],
            );
          },
        ),
        ..._animatingCards.map((animCard) {
          return AnimatedBuilder(
            animation: animCard.animation,
            builder: (context, child) {
              return Positioned(
                left: animCard.animation.value.dx,
                top: animCard.animation.value.dy,
                child: SizedBox(
                  width: 60,
                  height: 90,
                  child: game_card.Card(
                    cardNumber: animCard.cardNumber,
                    padding: 0,
                    isFlipped: animCard.type == AnimateCardType.draw
                        ? true
                        : false,
                    onTap: (_) {},
                    useExpanded: false,
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }
}
