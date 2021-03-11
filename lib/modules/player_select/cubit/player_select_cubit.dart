import "dart:async";

import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/model/player_config.dart";
import "package:among_us_helper/modules/app/cubit/player_config_cubit.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";
import "package:rxdart/rxdart.dart";

part "player_select_state.dart";

class PlayerSelectCubit extends Cubit<PlayerSelectState> {
  final Logger _logger = Logger("PlayerSelectCubit");

  /// Used to track disabled players and remove them from the options list.
  final PlayerConfigCubit _playerConfigCubit;

  /// Keeps track of our repository subscription.
  StreamSubscription<PlayerSelectLoadSuccess> _playerConfigSubscription;

  PlayerSelectCubit({@required PlayerConfigCubit playerConfigCubit})
      : this._playerConfigCubit = playerConfigCubit,
        super(PlayerSelectInitial()) {
    // Map our input cubit states to ones that contain data.
    Stream<List<PlayerConfig>> pathingEntryStream = _playerConfigCubit
        .startWith(_playerConfigCubit.state)
        .where((PlayerConfigState state) => state is PlayerConfigLoadSuccess)
        .map((PlayerConfigState state) => (state as PlayerConfigLoadSuccess).config);

    // Every time we receive new mapped data, emit it.
    _playerConfigSubscription = pathingEntryStream.map(_mapInputDataToState).listen(emit);
  }

  PlayerSelectLoadSuccess _mapInputDataToState(List<PlayerConfig> configs) {
    // Create a fresh state with all players unselected.
    Map<Player, bool> newState =
        Map.fromIterable(Player.values, key: (player) => player, value: (_) => false);

    // If we have a selection state present, copy over the current values.
    if (state is PlayerSelectLoadSuccess) {
      PlayerSelectLoadSuccess stateSuccess = state;
      newState.addAll(stateSuccess.selection);
    }

    // Remove all disabled players.
    newState.removeWhere((Player player, bool selected) =>
        configs.firstWhere((PlayerConfig config) => config.player == player).enabled == false);

    Map<Player, String> names = Map.fromIterable(configs,
        key: (config) => config.player,
        value: (config) => _textOrPlayerName(config.name, config.player));

    return PlayerSelectLoadSuccess(newState, names);
  }

  /// Toggles the selection state of the given [player].
  /// Only possible if we are in a loaded state.
  void togglePlayer(Player player) {
    if (state is! PlayerSelectLoadSuccess) {
      _logger.warning("No data. Cannot change state.");
      return;
    }
    PlayerSelectLoadSuccess stateSuccess = state;
    Map<Player, bool> duplicate = Map.of(stateSuccess.selection);
    duplicate[player] = !duplicate[player];

    emit(PlayerSelectLoadSuccess(duplicate, stateSuccess.names));
  }

  @override
  Future<void> close() {
    _playerConfigSubscription?.cancel();
    return super.close();
  }

  String _textOrPlayerName(String name, Player player) {
    if (name != null && name.isNotEmpty) {
      return name;
    }

    return player.getCamelName();
  }
}
