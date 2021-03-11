import "dart:async";

import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/model/player_config.dart";
import "package:among_us_helper/modules/app/cubit/pathing_cubit.dart";
import "package:among_us_helper/modules/app/cubit/player_config_cubit.dart";
import "package:bloc/bloc.dart";
import "package:meta/meta.dart";
import "package:rxdart/rxdart.dart";

part "pathing_view_state.dart";

class PathingViewCubit extends Cubit<PathingViewState> {
  final PathingCubit _pathingCubit;

  StreamSubscription<PathingViewLoadSuccess> _stateSubscription;

  PathingViewCubit(
      {@required PathingCubit pathingCubit, @required PlayerConfigCubit playerConfigCubit})
      : this._pathingCubit = pathingCubit,
        super(PathingViewInitial()) {
    // Map our input cubit states to ones that contain data.
    Stream<List<PathingEntry>> pathingEntryStream = _pathingCubit
        .startWith(_pathingCubit.state)
        .where((PathingState state) => state is PathingLoadSuccess)
        .map((PathingState state) => (state as PathingLoadSuccess).pathing);
    Stream<List<PlayerConfig>> playerConfigStream = playerConfigCubit
        .startWith(playerConfigCubit.state)
        .where((PlayerConfigState state) => state is PlayerConfigLoadSuccess)
        .map((PlayerConfigState state) => (state as PlayerConfigLoadSuccess).config);

    // Wait for both streams to push data once and then update with every push.
    // Map that data to a state.
    Stream<PathingViewLoadSuccess> stateStream = Rx.combineLatest2(
      pathingEntryStream,
      playerConfigStream,
      _mapInputDataToState,
    );

    // Every time we receive new mapped data, emit it.
    _stateSubscription = stateStream.listen(emit);
  }

  /// Maps the data received from the inputs to a success state,
  /// so that its easily accessible by the UI.
  PathingViewLoadSuccess _mapInputDataToState(
      List<PathingEntry> pathing, List<PlayerConfig> configs) {
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
    return PathingViewLoadSuccess(groupedPathing, names);
  }

  @override
  Future<void> close() {
    _stateSubscription?.cancel();
    return super.close();
  }
}
