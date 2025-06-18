import 'package:flutter/material.dart';
import 'package:speedy_poker/enums/player_id.dart';
import 'package:speedy_poker/model/player.dart';

class Game extends ChangeNotifier {
  late List<int> centerPile1;
  late List<int> centerPile2;
  late List<int> centerDrawPile1 = [];
  late List<int> centerDrawPile2 = [];
  late Player player1 = Player();
  late Player player2 = Player();
  late int roomID = -1;

  Game({
    List<int>? centerPile1,
    List<int>? centerPile2,
    List<int>? centerDrawPile1,
    List<int>? centerDrawPile2,
    Player? player1,
    Player? player2,
    int? roomID,
  }) {
    this.centerPile1 = centerPile1 ?? [];
    this.centerPile2 = centerPile2 ?? [];
    this.centerDrawPile1 = centerDrawPile1 ?? [];
    this.centerDrawPile2 = centerDrawPile2 ?? [];
    this.player1 = player1 ?? Player();
    this.player2 = player2 ?? Player();
    this.roomID = roomID ?? -1;

    notifyListeners();
  }

  set setCenterPile1(List<int> centerPile1) {
    this.centerPile1 = centerPile1;
    notifyListeners();
  }

  set setCenterPile2(List<int> centerPile2) {
    this.centerPile2 = centerPile2;
    notifyListeners();
  }

  set setCenterDrawPile1(List<int> centerDrawPile1) {
    this.centerDrawPile1 = centerDrawPile1;
    notifyListeners();
  }

  set setCenterDrawPile2(List<int> centerDrawPile2) {
    this.centerDrawPile2 = centerDrawPile2;
    notifyListeners();
  }

  set setPlayer1(Player player1) {
    this.player1 = player1;
    notifyListeners();
  }

  set setPlayer2(Player player2) {
    this.player2 = player2;
    notifyListeners();
  }

  set setRoomID(int roomID) {
    this.roomID = roomID;
    notifyListeners();
  }

  List<int> get getCenterPil1 => centerPile1;

  List<int> get getCenterPil2 => centerPile2;

  List<int> get getCenterDrawPile1 => centerDrawPile1;

  List<int> get getCenterDrawPile2 => centerDrawPile2;

  Player get getPlayer1 => player1;

  Player get getPlayer2 => player2;

  int get getRoomID => roomID;

  void updateFromGameState(Map<String, dynamic> gameState) {
    centerPile1 = List<int>.from(gameState['centerPile1']);
    centerPile2 = List<int>.from(gameState['centerPile2']);
    centerDrawPile1 = List<int>.from(gameState['centerDrawPile1']);
    centerDrawPile2 = List<int>.from(gameState['centerDrawPile2']);
    roomID = gameState['gameID'] as int;

    final newPlayer1 = gameState['player1'] as Map<String, dynamic>;
    final newPlayer2 = gameState['player2'] as Map<String, dynamic>;

    player1.setHand = List<int>.from(newPlayer1['hand']);
    player2.setHand = List<int>.from(newPlayer2['hand']);
    player1.setDrawPile = List<int>.from(newPlayer1['drawPile']);
    player2.setDrawPile = List<int>.from(newPlayer2['drawPile']);
    player1.setName = newPlayer1['name'] as String;
    player2.setName = newPlayer2['name'] as String;
    player1.setPoint = newPlayer1['point'] as int;
    player2.setPoint = newPlayer2['point'] as int;
    player1.setSocketID = newPlayer1['socketID'] as String;
    player2.setSocketID = newPlayer2['socketID'] as String;
    player1.setPlayerID = PlayerID.values[newPlayer1['playerID']];
    player2.setPlayerID = PlayerID.values[newPlayer2['playerID']];

    notifyListeners();
  }
}
