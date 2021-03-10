part of "player_select_cubit.dart";

@immutable
abstract class PlayerSelectState {}

class PlayerSelectInitial extends PlayerSelectState {}

class PlayerSelectLoadSuccess extends PlayerSelectState {
  final Map<Player, bool> selection;

  PlayerSelectLoadSuccess(this.selection);
}
