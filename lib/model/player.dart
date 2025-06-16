import 'package:speedy_poker/enums/player_id.dart';

class Player{
  List<int> drawPile = [1,2,3,4];
  List<int> hand = [1,2,3,4];
  PlayerId playerID = PlayerId.def;
  String socketID = '';
  String name = '';
  int point = 0;

  set setName(String name) => this.name = name;

  get getName => name;
}
