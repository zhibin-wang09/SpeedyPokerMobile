import 'package:flutter/material.dart';
import 'package:speedy_poker/enums/player_id.dart';

class Player extends ChangeNotifier {
  List<int> drawPile = [];
  List<int> hand = [];
  PlayerID playerID = PlayerID.def;
  String socketID = '';
  String name = '';
  int point = 0;

  set setName(String name) => this.name = name;

  set setDrawPile(List<int> drawPile) => this.drawPile = drawPile;

  set setHand(List<int> hand) => this.hand = hand;

  set setSocketID(String socketID) => this.socketID = socketID;

  set setPoint(int point) => this.point = point;

  set setPlayerID(PlayerID playerID) => this.playerID = playerID;

  get getName => name;

  get getDrawPile => drawPile;

  get getHand => hand;

  get getPlayerID => playerID;

  get getSocketID => socketID;

  get getPoint => point;

  Map<String, dynamic> toJson() => {
    'hand': hand,
    'drawPile': drawPile,
    'name': name,
    'point': point,
    'socketID': socketID,
    'playerID': playerID.index,
  };
}
