import "dart:async";

import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/model/player_config.dart";
import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";

part "player_select_state.dart";

class PlayerSelectCubit extends Cubit<PlayerSelectState> {
  final Logger _logger = Logger("PlayerSelectCubit");

  /// Used to track disabled players and remove them from the options list.
  final PlayerConfigRepository _playerConfigRepository;

  /// Keeps track of our repository subscription.
  StreamSubscription<List<PlayerConfig>> _playerConfigSubscription;

  PlayerSelectCubit({@required PlayerConfigRepository playerConfigRepository})
      : this._playerConfigRepository = playerConfigRepository,
        super(PlayerSelectInitial()) {
    Stream<List<PlayerConfig>> pathingEntryStream = _playerConfigRepository.playerConfigs;
    _playerConfigSubscription = pathingEntryStream.listen((List<PlayerConfig> event) {
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
          event.firstWhere((PlayerConfig config) => config.player == player).enabled == false);

      Map<Player, String> names = Map.fromIterable(event,
          key: (config) => config.player,
          value: (config) => _textOrPlayerName(config.name, config.player));

      // Push the new state.
      emit(PlayerSelectLoadSuccess(newState, names));
    });
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

  _textOrPlayerName(String name, Player player) {
    if (name != null && name.isNotEmpty) {
      return name;
    }

    String playerName = player.toString().split(".")[1].toLowerCase();
    String camelName = playerName.substring(0, 1).toUpperCase() + playerName.substring(1);

    return camelName;
  }
}
