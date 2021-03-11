import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/model/player_config.dart";
import "package:among_us_helper/modules/app/cubit/player_config_cubit.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";
import "package:rxdart/rxdart.dart";

part "player_config_view_state.dart";

class PlayerConfigViewCubit extends Cubit<PlayerConfigViewState> {
  final Logger _logger = Logger("PlayerConfigViewCubit");
  final PlayerConfigCubit _playerConfigCubit;

  PlayerConfigViewCubit({@required PlayerConfigCubit playerConfigCubit})
      : this._playerConfigCubit = playerConfigCubit,
        super(PlayerConfigViewInitial()) {
    _fetchCurrent();
  }

  /// Fetches a single, current map of the player names from the repository,
  /// and commits them as a state.
  void _fetchCurrent() {
    _playerConfigCubit
        .startWith(_playerConfigCubit.state)
        .where((PlayerConfigState state) => state is PlayerConfigLoadSuccess)
        .map((PlayerConfigState state) => (state as PlayerConfigLoadSuccess).config)
        .take(1)
        .map(_mapInputDataToState)
        .listen(emit)
        .onError((error, stackTrace) {
      _logger.severe("Could not fetch player config", error, stackTrace);
    });
  }

  /// Maps the data received from the inputs to a success state,
  /// so that its easily accessible by the UI.
  PlayerConfigViewLoadSuccess _mapInputDataToState(List<PlayerConfig> configs) {
    // Map names by the players in the config list.
    Map<Player, String> names = Map.fromIterable(
      configs,
      key: (config) => config.player,
      value: (config) => config.name,
    );

    // Map enables by the players in the config list.
    Map<Player, bool> enables = Map.fromIterable(
      configs,
      key: (config) => config.player,
      value: (config) => config.enabled,
    );

    // Emit a new state using the mapped config fields.
    return PlayerConfigViewLoadSuccess(names, enables);
  }

  /// Changes a given [player]"s name to the given [name].
  /// Does not commit the change to the repository, but emits an updated state.
  void updatePlayerName({@required Player player, @required String name}) {
    if (state is! PlayerConfigViewLoadSuccess) {
      _logger.warning("No player config data. Could not modify state.");
      return;
    }

    PlayerConfigViewLoadSuccess successState = state;

    // Copy the original predictions
    Map<Player, String> newPlayerNames = Map.of(successState.playerNames);

    // Move the player to the desired section
    newPlayerNames[player] = name;

    // Also copy over the enables, but dont modify them.
    Map<Player, bool> newPlayerEnables = Map.of(successState.playerEnables);

    emit(PlayerConfigViewLoadSuccess(newPlayerNames, newPlayerEnables));
  }

  void updatePlayerEnabled({@required Player player, @required bool enabled}) {
    if (state is! PlayerConfigViewLoadSuccess) {
      _logger.warning("No player config data. Could not modify state.");
      return;
    }

    PlayerConfigViewLoadSuccess successState = state;

    // Copy the original predictions
    Map<Player, bool> newPlayerEnables = Map.of(successState.playerEnables);

    // Move the player to the desired section
    newPlayerEnables[player] = enabled;

    // Also copy over the enables, but dont modify them.
    Map<Player, String> newPlayerNames = Map.of(successState.playerNames);

    emit(PlayerConfigViewLoadSuccess(newPlayerNames, newPlayerEnables));
  }

  /// Resets all the player names to empty strings.
  /// Does not commit the change to the repository.
  void reset() {
    Map<Player, String> emptyPlayerNames =
        Map.fromEntries(Player.values.map((Player player) => MapEntry(player, "")));
    Map<Player, bool> enabledPlayers =
        Map.fromEntries(Player.values.map((Player player) => MapEntry(player, true)));

    emit(PlayerConfigViewLoadSuccess(emptyPlayerNames, enabledPlayers));
  }

  /// Commits the current state to the repository.
  void submit() {
    if (state is! PlayerConfigViewLoadSuccess) {
      _logger.warning("Cannot submit new config while loading data.");
      return;
    }

    PlayerConfigViewLoadSuccess stateSuccess = state;
    List<PlayerConfig> playerConfigs = Player.values.map((Player player) {
      String name = stateSuccess.playerNames[player];
      bool enabled = stateSuccess.playerEnables[player];
      return PlayerConfig(
        player: player,
        name: name,
        enabled: enabled,
      );
    }).toList();
    _playerConfigCubit.updateAll(playerConfigs);
  }
}
