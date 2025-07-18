import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:speedy_poker/enums/animated_card_type.dart';
import 'package:speedy_poker/enums/destination.dart';
import 'package:speedy_poker/enums/player_id.dart';
import 'package:speedy_poker/model/game.dart';
import 'package:speedy_poker/model/game_response.dart';
import 'package:speedy_poker/model/player.dart';
import 'package:speedy_poker/model/socket.dart';
import 'package:speedy_poker/util/helper_function.dart';
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
  late Game _game;

  List<GlobalKey> _opponentPlayerKeys = [];
  List<GlobalKey> _centerPileKeys = [];
  List<GlobalKey> _localPlayerKeys = [];

  final GlobalKey _stackKey = GlobalKey();

  Player _localPlayer = Player();
  Player _opponentPlayer = Player();

  final List<AnimatingCard> _animatingCards = [];

  bool haveWinner = false;

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
    haveWinner = false;
    _game = Game();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    socketService = Provider.of<SocketService>(context, listen: false);

    socketService.emit('game:get', widget.roomID);
    socketService.socket.on('game:update', _handleReceiveGameState);
    socketService.socket.on('game:result', _handleResult);
    socketService.socket.on('game:disconnect', _handleEndGame);
    socketService.socket.on("game:error", _handleGameError);
  }

  void _handleGameError(dynamic json) {
    String errorMessage = json as String;

    showErrorAndBack(
      context,
      errorMessage,
      ToastGravity.BOTTOM,
      const Color.fromARGB(255, 229, 104, 116),
      Colors.white,
    );
  }

  void _handleResult(dynamic json) {
    String res = json as String;
    if (res.toLowerCase().contains('won')) {
      setState(() {
        haveWinner = true;
      });
    }

    showErrorAndBack(
      context,
      res,
      ToastGravity.BOTTOM,
      haveWinner
          ? const Color.fromARGB(255, 106, 235, 110)
          : const Color.fromARGB(255, 224, 117, 128),
      Colors.white,
    );
  }

  void _handleEndGame(dynamic json) {
    String res = json as String;

    showErrorAndBack(
      context,
      res,
      ToastGravity.BOTTOM,
      const Color.fromARGB(255, 229, 104, 116),
      Colors.white,
    );
  }

  void _handleReceiveGameState(dynamic json) {
    if (!mounted || json == null) return;
    final res = UpdatedGameResponse.fromJson(json);

    setState(() {
      _game.updateFromGameState(res.game);
    });

    final localPlayer = _game.getPlayer1.getSocketID == socketService.socket.id
        ? _game.getPlayer1
        : _game.getPlayer2;

    final opponentPlayer =
        _game.getPlayer1.getSocketID == socketService.socket.id
        ? _game.getPlayer2
        : _game.getPlayer1;

    setState(() {
      _localPlayer = localPlayer;
      _opponentPlayer = opponentPlayer;
    });

    if (res.playerTurn == PlayerID.def) return;

    _startAnimation(res.playerTurn, res.cardIndex, res.destination);
    if (res.newCard != -1) {
      _startAnimationDrawToHand(res.playerTurn, res.cardIndex, res.newCard);
    }
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
      size: toBox.size,
    );

    setState(() => _animatingCards.add(animCard));

    controller.forward().whenComplete(() {
      setState(() => _animatingCards.remove(animCard));
      controller.dispose();
    });
  }

  @override
  void dispose() {
    socketService.socket.off('game:update', _handleReceiveGameState);
    socketService.socket.off('game:result', _handleResult);
    socketService.socket.off('game:disconnect', _handleEndGame);
    socketService.socket.off('game:error', _handleGameError);
    for (var card in _animatingCards) {
      card.controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/poker_table_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            key: _stackKey,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Hand(
                    hand: _opponentPlayer.getHand,
                    drawPile: _opponentPlayer.getDrawPile,
                    padding: 10,
                    isFlipped: true,
                    onTap: (_) {},
                    keys: _opponentPlayerKeys,
                    isLocalPlayer: false,
                    points: _opponentPlayer.getPoint,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Pile(
                        cards: _game.getCenterDrawPile1,
                        padding: 8,
                        isFlipped: true,
                        uniqueKey: _centerPileKeys[0],
                      ),
                      Pile(
                        cards: _game.getCenterPile1,
                        padding: 8,
                        isFlipped: false,
                        uniqueKey: _centerPileKeys[2],
                      ),
                      Pile(
                        cards: _game.getCenterPile2,
                        padding: 8,
                        isFlipped: false,
                        uniqueKey: _centerPileKeys[3],
                      ),
                      Pile(
                        cards: _game.getCenterDrawPile2,
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
                      socketService.emit('game:move', {
                        "card": cardNumber,
                        "gameId": _game.getRoomID,
                        "playerId": _localPlayer.getPlayerID.index,
                      });
                    },
                    keys: _localPlayerKeys,
                    isLocalPlayer: true,
                    points: _localPlayer.getPoint,
                  ),
                ],
              ),
              ..._animatingCards.map((animCard) {
                return AnimatedBuilder(
                  animation: animCard.animation,
                  builder: (context, child) {
                    return Positioned(
                      left: animCard.animation.value.dx,
                      top: animCard.animation.value.dy,
                      child: SizedBox(
                        width: animCard.size.width,
                        height: animCard.size.height,
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
          ),
        ),
      ),
    );
  }
}
