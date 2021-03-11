part of "player_config_cubit.dart";

@immutable
abstract class PlayerConfigState {}

class PlayerConfigLoadSuccess extends PlayerConfigState {
  final List<PlayerConfig> config;

  PlayerConfigLoadSuccess(List<PlayerConfig> config) : this.config = List.unmodifiable(config);
}
