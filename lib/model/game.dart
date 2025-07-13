import 'package:flutter/material.dart';
import 'package:speedy_poker/model/player.dart';

class Game extends ChangeNotifier {
  late List<int> _centerPile1;
  late List<int> _centerPile2;
  late List<int> _centerDrawPile1 = [];
  late List<int> _centerDrawPile2 = [];
  late Player _player1;
  late Player _player2;
  late int _roomID = -1;

  Game({
    List<int>? centerPile1,
    List<int>? centerPile2,
    List<int>? centerDrawPile1,
    List<int>? centerDrawPile2,
    Player? player1,
    Player? player2,
    List<Player>? players,
    int? roomID,
  }) {
    _centerPile1 = centerPile1 ?? [];
    _centerPile2 = centerPile2 ?? [];
    _centerDrawPile1 = centerDrawPile1 ?? [];
    _centerDrawPile2 = centerDrawPile2 ?? [];
    _player1 = player1 ?? Player();
    _player2 = player2 ?? Player();
    _roomID = roomID ?? -1;

    notifyListeners();
  }

  set setCenterPile1(List<int> centerPile1) {
    _centerPile1 = centerPile1;
    notifyListeners();
  }

  set setCenterPile2(List<int> centerPile2) {
    _centerPile2 = centerPile2;
    notifyListeners();
  }

  set setCenterDrawPile1(List<int> centerDrawPile1) {
    _centerDrawPile1 = centerDrawPile1;
    notifyListeners();
  }

  set setCenterDrawPile2(List<int> centerDrawPile2) {
    _centerDrawPile2 = centerDrawPile2;
    notifyListeners();
  }

  set setPlayer1(Player player1) {
    _player1 = player1;
    notifyListeners();
  }

  set setPlayer2(Player player2) {
    _player2 = player2;
    notifyListeners();
  }

  set setRoomID(int roomID) {
    _roomID = roomID;
    notifyListeners();
  }

  List<int> get getCenterPile1 => _centerPile1;

  List<int> get getCenterPile2 => _centerPile2;

  List<int> get getCenterDrawPile1 => _centerDrawPile1;

  List<int> get getCenterDrawPile2 => _centerDrawPile2;

  Player get getPlayer1 => _player1;

  Player get getPlayer2 => _player2;

  int get getRoomID => _roomID;

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      centerPile1: List<int>.from(json['centerPile1']),
      centerPile2: List<int>.from(json['centerPile2']),
      centerDrawPile1: List<int>.from(json['centerDrawPile1']),
      centerDrawPile2: List<int>.from(json['centerDrawPile2']),
      roomID: json['gameID'] as int,
      player1: Player.fromJson(json['players'][1]),
      player2: Player.fromJson(json['players'][0]),
    );
  }

  void updateFromGameState(Game game) {
    _centerPile1 = List<int>.from(game.getCenterPile1);
    _centerPile2 = List<int>.from(game.getCenterPile2);
    _centerDrawPile1 = List<int>.from(game.getCenterDrawPile1);
    _centerDrawPile2 = List<int>.from(game.getCenterDrawPile2);
    _roomID = game.getRoomID;

    final newPlayer1 = game.getPlayer1;
    final newPlayer2 = game.getPlayer2;

    _player1.setHand = newPlayer1.getHand;
    _player2.setHand = newPlayer2.getHand;
    _player1.setDrawPile = newPlayer1.getDrawPile;
    _player2.setDrawPile = newPlayer2.getDrawPile;
    _player1.setName = newPlayer1.getName;
    _player2.setName = newPlayer2.getName;
    _player1.setPoint = newPlayer1.getPoint;
    _player2.setPoint = newPlayer2.getPoint;
    _player1.setSocketID = newPlayer1.getSocketID;
    _player2.setSocketID = newPlayer2.getSocketID;
    _player1.setPlayerID = newPlayer1.getPlayerID;
    _player2.setPlayerID = newPlayer2.getPlayerID;

    notifyListeners();
  }
}
