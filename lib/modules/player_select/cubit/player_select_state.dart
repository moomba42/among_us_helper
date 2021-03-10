part of "player_select_cubit.dart";

@immutable
abstract class PlayerSelectState {}

class PlayerSelectInitial extends PlayerSelectState {}

class PlayerSelectLoadSuccess extends PlayerSelectState {
  final Map<Player, bool> selection;
  final Map<Player, String> names;

  PlayerSelectLoadSuccess(this.selection, this.names);
}
