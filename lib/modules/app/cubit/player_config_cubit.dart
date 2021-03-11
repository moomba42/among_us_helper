import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/model/player_config.dart";
import "package:bloc/bloc.dart";
import "package:meta/meta.dart";

part "player_config_state.dart";

/// Tracks state of player configurations which include variables
/// like name or enabled state for each possible player.
class PlayerConfigCubit extends Cubit<PlayerConfigState> {
  PlayerConfigCubit() : super(PlayerConfigLoadSuccess(_buildDefaultPlayerConfig()));

  /// Replaces an existing player configuration for the given [player] with a new one,
  /// constructed from the given [player], [name] and [enabled] arguments.
  void updatePlayerConfig(Player player, String name, bool enabled) {
    PlayerConfigLoadSuccess stateSuccess = state;
    List<PlayerConfig> updatedList = List.of(stateSuccess.config)
      ..removeWhere((PlayerConfig config) => config.player == player)
      ..add(PlayerConfig(player: player, name: name, enabled: enabled));
    emit(PlayerConfigLoadSuccess(updatedList));
  }

  /// Puts all entries of [updatedConfigs] into the current configs,
  /// replacing old ones, matching by player.
  void updateAll(List<PlayerConfig> updatedConfigs) {
    PlayerConfigLoadSuccess stateSuccess = state;

    // Create a new list of configs
    List<PlayerConfig> newConfigs = [];

    // Duplicate current data into new list
    newConfigs.addAll(stateSuccess.config);

    // Remove duplicates
    newConfigs.removeWhere((PlayerConfig left) =>
        updatedConfigs.any((PlayerConfig right) => left.player == right.player));

    // Add new entries
    newConfigs.addAll(updatedConfigs);

    // Push changes
    emit(PlayerConfigLoadSuccess(newConfigs));
  }

  /// Resets the state to a default configuration.
  void reset() {
    emit(PlayerConfigLoadSuccess(_buildDefaultPlayerConfig()));
  }

  /// Builds a default player configuration list,
  /// with all players being enabled and having no name.
  static List<PlayerConfig> _buildDefaultPlayerConfig() {
    return Player.values.map((Player player) {
      return PlayerConfig(
        player: player,
        name: "",
        enabled: true,
      );
    }).toList();
  }
}
