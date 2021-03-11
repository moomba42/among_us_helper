import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/model/player_config.dart";
import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";

part "player_config_state.dart";

class PlayerConfigCubit extends Cubit<PlayerConfigState> {
  final Logger _logger = Logger("PlayerConfigCubit");
  final PlayerConfigRepository _playerConfigRepository;

  PlayerConfigCubit({@required PlayerConfigRepository playerConfigRepository})
      : this._playerConfigRepository = playerConfigRepository,
        super(PlayerConfigInitial());

  /// Fetches a single, current map of the player names from the repository,
  /// and commits them as a state.
  void fetch() {
    _playerConfigRepository.playerConfigs.take(1).listen((List<PlayerConfig> value) {
      Map<Player, String> names = Map.fromIterable(
        value,
        key: (config) => config.player,
        value: (config) => config.name,
      );
      Map<Player, bool> enables = Map.fromIterable(
        value,
        key: (config) => config.player,
        value: (config) => config.enabled,
      );
      emit(PlayerConfigLoadSuccess(names, enables));
    }).onError((error, stackTrace) {
      _logger.severe("Could not fetch player config", error, stackTrace);
    });
  }

  /// Changes a given [player]'s name to the given [name].
  /// Does not commit the change to the repository, but emits an updated state.
  void updatePlayerName({@required Player player, @required String name}) {
    if (state is! PlayerConfigLoadSuccess) {
      _logger.warning("No player config data. Could not modify state.");
      return;
    }

    PlayerConfigLoadSuccess successState = state;

    // Copy the original predictions
    Map<Player, String> newPlayerNames = Map.of(successState.playerNames);

    // Move the player to the desired section
    newPlayerNames[player] = name;

    // Also copy over the enables, but dont modify them.
    Map<Player, bool> newPlayerEnables = Map.of(successState.playerEnables);

    emit(PlayerConfigLoadSuccess(newPlayerNames, newPlayerEnables));
  }

  void updatePlayerEnabled({@required Player player, @required bool enabled}) {
    if (state is! PlayerConfigLoadSuccess) {
      _logger.warning("No player config data. Could not modify state.");
      return;
    }

    PlayerConfigLoadSuccess successState = state;

    // Copy the original predictions
    Map<Player, bool> newPlayerEnables = Map.of(successState.playerEnables);

    // Move the player to the desired section
    newPlayerEnables[player] = enabled;

    // Also copy over the enables, but dont modify them.
    Map<Player, String> newPlayerNames = Map.of(successState.playerNames);

    emit(PlayerConfigLoadSuccess(newPlayerNames, newPlayerEnables));
  }

  /// Resets all the player names to empty strings.
  /// Does not commit the change to the repository.
  void reset() {
    Map<Player, String> emptyPlayerNames =
        Map.fromEntries(Player.values.map((Player player) => MapEntry(player, "")));
    Map<Player, bool> enabledPlayers =
        Map.fromEntries(Player.values.map((Player player) => MapEntry(player, true)));

    emit(PlayerConfigLoadSuccess(emptyPlayerNames, enabledPlayers));
  }

  /// Commits the current state to the repository.
  void submit() {
    if (state is! PlayerConfigLoadSuccess) {
      _logger.warning("Cannot submit new config while loading data.");
      return;
    }

    PlayerConfigLoadSuccess stateSuccess = state;
    List<PlayerConfig> playerConfigs = Player.values.map((Player player) {
      String name = stateSuccess.playerNames[player];
      bool enabled = stateSuccess.playerEnables[player];
      return PlayerConfig(
        player: player,
        name: name,
        enabled: enabled,
      );
    }).toList();
    _playerConfigRepository.update(playerConfigs);
  }
}
