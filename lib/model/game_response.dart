import 'package:speedy_poker/enums/destination.dart';
import 'package:speedy_poker/enums/player_id.dart';
import 'package:speedy_poker/model/game.dart';

class UpdatedGameResponse {
  final Game game;
  final PlayerID playerTurn;
  final int cardIndex;
  final Destination destination;
  final int newCard;

  UpdatedGameResponse({
    required this.game,
    required this.playerTurn,
    required this.cardIndex,
    required this.destination,
    required this.newCard,
  });

  factory UpdatedGameResponse.fromJson(Map<String, dynamic> json) {
    return UpdatedGameResponse(
      game: Game.fromJson(json['game']),
      playerTurn: PlayerID.values[json['playerTurn']],
      cardIndex: json['cardIndex'] as int,
      destination: Destination.values[json['destination']],
      newCard: json['newCard'] as int,
    );
  }
}