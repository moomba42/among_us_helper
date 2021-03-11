part of "player_config_view_cubit.dart";

@immutable
abstract class PlayerConfigViewState {}

class PlayerConfigViewInitial extends PlayerConfigViewState {}

class PlayerConfigViewLoadSuccess extends PlayerConfigViewState {
  final Map<Player, String> playerNames;
  final Map<Player, bool> playerEnables;

  PlayerConfigViewLoadSuccess(this.playerNames, this.playerEnables);
}
