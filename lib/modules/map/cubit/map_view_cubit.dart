import "dart:async";
import "dart:math";
import "dart:ui";

import "package:among_us_helper/core/model/au_map.dart";
import "package:among_us_helper/core/model/map_location.dart";
import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/app/cubit/map_cubit.dart";
import "package:among_us_helper/modules/app/cubit/pathing_cubit.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";
import "package:rxdart/rxdart.dart";

part "map_view_state.dart";

class MapViewCubit extends Cubit<MapViewState> {
  final Logger _logger = Logger("MapViewCubit");
  final MapCubit _mapCubit;
  final PathingCubit _pathingCubit;

  StreamSubscription<MapViewLoadSuccess> _stateSubscription;

  MapViewCubit({@required MapCubit mapCubit, @required PathingCubit pathingCubit})
      : this._mapCubit = mapCubit,
        this._pathingCubit = pathingCubit,
        super(MapViewInitial()) {
    // Map our input cubit states to ones that contain data.
    Stream<AUMap> mapStream = _mapCubit
        .startWith(_mapCubit.state)
        .where((MapState state) => state is MapSelected)
        .map((MapState state) => (state as MapSelected).selectedMap);
    Stream<List<PathingEntry>> pathingStream = _pathingCubit
        .startWith(_pathingCubit.state)
        .where((PathingState state) => state is PathingLoadSuccess)
        .map((PathingState state) => (state as PathingLoadSuccess).pathing);


    // Wait for both streams to push data once and then update with every push.
    // Map that data to a state.
    Stream<MapViewLoadSuccess> stateStream = Rx.combineLatest2(
      mapStream,
      pathingStream,
      _mapInputDataToState,
    );

    // Every time we receive new mapped data, emit it.
    _stateSubscription = stateStream.listen(emit);
  }

  /// Maps the data received from the inputs to a success state,
  /// so that its easily accessible by the UI.
  MapViewLoadSuccess _mapInputDataToState(AUMap selectedMap, List<PathingEntry> pathing) {
    return MapViewLoadSuccess(selectedMap, pathing);
  }

  // Proxies the map change to the [MapCubit].
  void setMap(AUMap map) {
    _mapCubit.changeSelection(map);
  }

  /// Builds a new pathing entry at the given [position], with the given [players],
  /// as well as the current time and selected map.
  /// After that the newly generated entry is pushed to the [PathingCubit].
  void createPathingEntryAt({Offset position, Set<Player> players}) {
    if (state is! MapViewLoadSuccess) {
      _logger.warning("Can't create pathing entry as the map is not loaded yet.");
      return;
    }

    // Get the loaded state.
    MapViewLoadSuccess stateSuccess = state;

    // Get the list of locations available for the currently selected map.
    List<MapLocation> locations = stateSuccess.map.getLocations();

    // Determine if the click location intersects with one of the locations.
    MapLocation clickedLocation = locations.firstWhere(
      (MapLocation location) => location.bounds.any((Rect rect) => rect.contains(position)),
      orElse: () => null,
    );

    // Get the current time.
    int time = DateTime.now().millisecondsSinceEpoch;

    // Construct a new entry using the previously calculated variables.
    PathingEntry newEntry = PathingEntry(
      location: clickedLocation,
      position: Point<double>(position.dx, position.dy),
      time: time,
      players: players,
    );

    _logger.info("Created new pathing entry at ($position, ${clickedLocation?.name})");

    // Emit the new entry to the pathing cubit.
    _pathingCubit.addEntry(newEntry);
  }

  @override
  Future<void> close() {
    _stateSubscription?.cancel();
    return super.close();
  }
}
