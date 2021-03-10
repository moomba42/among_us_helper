import "dart:async";

import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/model/player_config.dart";
import "package:among_us_helper/modules/pathing/repository/pathing_repository.dart";
import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";
import "package:rxdart/rxdart.dart";

part "pathing_state.dart";

class PathingCubit extends Cubit<PathingState> {
  final Logger _logger = Logger("PathingCubit");
  final PathingRepository _pathingRepository;

  StreamSubscription<PathingLoadSuccess> _repositoriesSubscription;

  PathingCubit(
      {@required PathingRepository pathingRepository,
      @required PlayerConfigRepository playerConfigRepository})
      : this._pathingRepository = pathingRepository,
        super(PathingInitial()) {
    // Get our repo streams.
    Stream<List<PathingEntry>> pathingEntryStream = _pathingRepository.pathing;
    Stream<List<PlayerConfig>> playerConfigStream = playerConfigRepository.playerConfigs;

    // Wait for both streams to push data once and then update with every push.
    // Map that data to a state.
    Stream<PathingLoadSuccess> stateStream = Rx.combineLatest2(
      pathingEntryStream,
      playerConfigStream,
      _mapRepoDataToState,
    );

    // Every time we receive new mapped data, emit it.
    _repositoriesSubscription = stateStream.listen(emit);
  }

  /// Maps the data received from the repos ([pathing], [configs]) to a success state,
  /// so that its easily accessible by the UI.
  PathingLoadSuccess _mapRepoDataToState(List<PathingEntry> pathing, List<PlayerConfig> configs) {
    // Group pathing entries by player.
    Map<Player, List<PathingEntry>> groupedPathing = {};
    pathing.forEach(
      (PathingEntry entry) => entry.players.forEach(
        (Player player) => groupedPathing.putIfAbsent(player, () => []).add(entry),
      ),
    );

    // Remove disabled players from the map.
    groupedPathing.removeWhere((Player player, List<PathingEntry> pathing) =>
        configs.firstWhere((PlayerConfig config) => config.player == player).enabled == false);

    // Map player names by player
    Map<Player, String> names = Map.fromIterable(
      configs,
      key: (config) => config.player,
      value: (config) => config.name,
    );

    // Construct a state with the transformed data.
    return PathingLoadSuccess(groupedPathing, names);
  }

  @override
  Future<void> close() {
    _repositoriesSubscription?.cancel();
    return super.close();
  }
}
