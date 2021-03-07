part of "player_config_cubit.dart";

@immutable
abstract class PlayerConfigState {}

class PlayerConfigInitial extends PlayerConfigState {}

class PlayerConfigLoadSuccess extends PlayerConfigState {
  final Map<Player, String> playerNames;
  final Map<Player, bool> playerEnables;

  PlayerConfigLoadSuccess(this.playerNames, this.playerEnables);
}
