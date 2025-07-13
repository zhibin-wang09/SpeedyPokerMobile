import 'package:speedy_poker/enums/player_id.dart';

class Player {
  late List<int> _drawPile;
  late List<int> _hand;
  late PlayerID _playerID;
  late String _socketID;
  late String _name;
  late double _point;

  Player({
    List<int>? drawPile,
    List<int>? hand,
    PlayerID? playerID,
    String? socketID,
    String? name,
    double? point,
  }) {
    _drawPile = drawPile ?? [];
    _hand = hand ?? [];
    _playerID = playerID ?? PlayerID.def;
    _socketID = socketID ?? '';
    _name = name ?? '';
    _point = point ?? 0;
  }

  set setName(String name) => _name = name;

  set setDrawPile(List<int> drawPile) => _drawPile = drawPile;

  set setHand(List<int> hand) => _hand = hand;

  set setSocketID(String socketID) => _socketID = socketID;

  set setPoint(double point) => _point = point;

  set setPlayerID(PlayerID playerID) => _playerID = playerID;

  String get getName => _name;

  List<int> get getDrawPile => _drawPile;

  List<int> get getHand => _hand;

  PlayerID get getPlayerID => _playerID;

  String get getSocketID => _socketID;

  double get getPoint => _point;

  Map<String, dynamic> toJson() => {
    'hand': _hand,
    'drawPile': _drawPile,
    'name': _name,
    'point': _point,
    'socketID': _socketID,
    'playerID': _playerID.index,
  };

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      hand: List<int>.from(json['hand']),
      drawPile: List<int>.from(json['drawPile']),
      name: json['name'] as String,
      point: (json['point'] as num).toDouble(),
      socketID: json['socketId'] as String,
      playerID: PlayerID.values[json['playerId']],
    );
  }
}
