import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/player_names/repositories/player_names_repository.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";

part "player_names_state.dart";

class PlayerNamesCubit extends Cubit<PlayerNamesState> {
  final Logger _logger = Logger("PlayerNamesCubit");
  final PlayerNamesRepository _playerNamesRepository;

  PlayerNamesCubit({@required PlayerNamesRepository playerNamesRepository})
      : this._playerNamesRepository = playerNamesRepository,
        super(PlayerNamesInitial());

  /// Fetches a single, current map of the player names from the repository,
  /// and commits them as a state.
  void fetch() {
    _playerNamesRepository.playerNames.take(1).listen((Map<Player, String> value) {
      emit(PlayerNamesLoadSuccess(value));
    }).onError((error, stackTrace) {
      _logger.severe("Could not fetch player names", error, stackTrace);
    });
  }

  /// Changes a given [player]'s name to the given [name].
  /// Does not commit the change to the repository, but emits an updated state.
  void change({@required Player player, @required String name}) {
    if (state is! PlayerNamesLoadSuccess) {
      _logger.warning("No player names data. Could not modify state.");
      return;
    }

    PlayerNamesLoadSuccess successState = state;

    // Copy the original predictions
    Map<Player, String> newPlayerNames = Map.of(successState.playerNames);

    // Move the player to the desired section
    newPlayerNames[player] = name;

    emit(PlayerNamesLoadSuccess(newPlayerNames));
  }

  /// Resets all the player names to empty strings.
  /// Does not commit the change to the repository.
  void reset() {
    Map<Player, String> emptyPlayerNames =
        Map.fromEntries(Player.values.map((Player player) => MapEntry(player, "")));

    emit(PlayerNamesLoadSuccess(emptyPlayerNames));
  }

  /// Commits the current state to the repository.
  void submit() {
    if (state is! PlayerNamesLoadSuccess) {
      _logger.warning("Cannot submit new names while loading data.");
      return;
    }

    PlayerNamesLoadSuccess stateSuccess = state;
    _playerNamesRepository.update(stateSuccess.playerNames);
  }
}
