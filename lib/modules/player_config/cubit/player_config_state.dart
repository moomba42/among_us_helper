part of "player_config_cubit.dart";

@immutable
abstract class PlayerConfigState {}

class PlayerConfigInitial extends PlayerConfigState {}

class PlayerConfigLoadSuccess extends PlayerConfigState {
  // TODO: Use PlayerNames type alias after dart adds the feature.
  final Map<Player, String> playerNames;

  PlayerConfigLoadSuccess(this.playerNames);
}
