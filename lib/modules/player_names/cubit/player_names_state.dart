part of "player_names_cubit.dart";

@immutable
abstract class PlayerNamesState {}

class PlayerNamesInitial extends PlayerNamesState {}

class PlayerNamesLoadSuccess extends PlayerNamesState {
  // TODO: Use PlayerNames type alias after dart adds the feature.
  final Map<Player, String> playerNames;

  PlayerNamesLoadSuccess(this.playerNames);
}
