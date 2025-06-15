import 'package:flutter/material.dart';
import 'package:speedy_poker/model/player.dart';

class Game extends ChangeNotifier {
  List<int> centerPile1 = [1,2,3];
  List<int> centerPile2 = [4,5,6];
  List<int> centerDrawPile1 = [7,8,9];
  List<int> centerDrawPile2 = [10,11,12];
  Player player1 = Player();
  Player player2 = Player();

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

  List<int> get getCenterPil1 => centerPile1;

  List<int> get getCenterPil2 => centerPile2;

  List<int> get getCenterDrawPile1 => centerDrawPile1;

  List<int> get getCenterDrawPile2 => centerDrawPile2;

  Player get getPlayer1 => player1;

  Player get getPlayer2 => player2;
}
