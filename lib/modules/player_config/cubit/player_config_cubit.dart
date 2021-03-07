import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";

part "player_config_state.dart";

class PlayerConfigCubit extends Cubit<PlayerConfigState> {
  final Logger _logger = Logger("PlayerNamesCubit");
  final PlayerConfigRepository _playerConfigRepository;

  PlayerConfigCubit({@required PlayerConfigRepository playerConfigRepository})
      : this._playerConfigRepository = playerConfigRepository,
        super(PlayerConfigInitial());

  /// Fetches a single, current map of the player names from the repository,
  /// and commits them as a state.
  void fetch() {
    _playerConfigRepository.playerNames.take(1).listen((Map<Player, String> value) {
      emit(PlayerConfigLoadSuccess(value));
    }).onError((error, stackTrace) {
      _logger.severe("Could not fetch player config", error, stackTrace);
    });
  }

  /// Changes a given [player]'s name to the given [name].
  /// Does not commit the change to the repository, but emits an updated state.
  void change({@required Player player, @required String name}) {
    if (state is! PlayerConfigLoadSuccess) {
      _logger.warning("No player config data. Could not modify state.");
      return;
    }

    PlayerConfigLoadSuccess successState = state;

    // Copy the original predictions
    Map<Player, String> newPlayerNames = Map.of(successState.playerNames);

    // Move the player to the desired section
    newPlayerNames[player] = name;

    emit(PlayerConfigLoadSuccess(newPlayerNames));
  }

  /// Resets all the player names to empty strings.
  /// Does not commit the change to the repository.
  void reset() {
    Map<Player, String> emptyPlayerNames =
        Map.fromEntries(Player.values.map((Player player) => MapEntry(player, "")));

    emit(PlayerConfigLoadSuccess(emptyPlayerNames));
  }

  /// Commits the current state to the repository.
  void submit() {
    if (state is! PlayerConfigLoadSuccess) {
      _logger.warning("Cannot submit new config while loading data.");
      return;
    }

    PlayerConfigLoadSuccess stateSuccess = state;
    _playerConfigRepository.update(stateSuccess.playerNames);
  }
}
