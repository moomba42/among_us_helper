import "dart:async";
import "dart:math";
import "dart:ui";

import "package:among_us_helper/core/model/au_map.dart";
import "package:among_us_helper/core/model/map_location.dart";
import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/pathing/repository/pathing_repository.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";

part "map_state.dart";

class MapCubit extends Cubit<MapState> {
  final Logger _logger = Logger("MapCubit");
  final PathingRepository _pathingRepository;

  StreamSubscription<List<PathingEntry>> _pathingSubscription;

  MapCubit({@required PathingRepository pathingRepository})
      : this._pathingRepository = pathingRepository,
        super(MapInitial()) {
    Stream<List<PathingEntry>> pathingEntryStream = _pathingRepository.pathing;
    _pathingSubscription = pathingEntryStream.listen((List<PathingEntry> event) {
      if (state is MapLoadSuccess) {
        MapLoadSuccess stateSuccess = state;
        emit(MapLoadSuccess(stateSuccess.map, event));
      }
    });

    // TODO: Use hydrated cubit
    setMap(AUMap.MIRA);
  }

  void setMap(AUMap map) async {
    await _pathingRepository.reset();
    List<PathingEntry> pathingSingle = await _pathingRepository.getPathing();
    emit(MapLoadSuccess(map, pathingSingle));
  }

  void addPathingEntry(PathingEntry pathingEntry) {
    _pathingRepository.addPathingEntry(pathingEntry);
  }

  @override
  Future<void> close() {
    _pathingSubscription?.cancel();
    return super.close();
  }

  void createPathingEntryAt({Offset position, Set<Player> players}) {
    if (state is! MapLoadSuccess) {
      _logger.warning("Can't create pathing entry as the map is not loaded yet.");
      return;
    }

    MapLoadSuccess stateSuccess = state;
    List<MapLocation> locations = stateSuccess.map.getLocations();
    MapLocation clickedLocation = locations.firstWhere(
      (MapLocation location) => location.bounds.any((Rect rect) => rect.contains(position)),
      orElse: () => null,
    );
    int time = DateTime.now().millisecondsSinceEpoch;
    PathingEntry newEntry = PathingEntry(
      location: clickedLocation,
      position: Point<double>(position.dx, position.dy),
      time: time,
      players: players,
    );

    _logger.info("Created new pathing entry at ($position, ${clickedLocation?.name})");

    _pathingRepository.addPathingEntry(newEntry);
  }
}
