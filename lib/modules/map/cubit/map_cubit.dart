import "dart:async";

import "package:among_us_helper/core/model/au_map.dart";
import "package:among_us_helper/core/model/map_location.dart";
import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:among_us_helper/modules/map/repository/map_location_repository.dart";
import "package:among_us_helper/modules/pathing/repository/pathing_repository.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";

part "map_state.dart";

class MapCubit extends Cubit<MapState> {
  final Logger _logger = Logger("PlayerNamesCubit");
  final MapLocationRepository _mapLocationRepository;
  final PathingRepository _pathingRepository;

  StreamSubscription<List<PathingEntry>> _pathingSubscription;

  MapCubit({@required MapLocationRepository mapLocationRepository, @required PathingRepository pathingRepository})
      : this._mapLocationRepository = mapLocationRepository,
        this._pathingRepository = pathingRepository,
        super(MapInitial()) {
    Stream<List<PathingEntry>> pathingEntryStream = _pathingRepository.pathing;
    _pathingSubscription = pathingEntryStream.listen((List<PathingEntry> event) {
      if(state is MapLoadSuccess) {
        MapLoadSuccess stateSuccess = state;
        emit(MapLoadSuccess(stateSuccess.map, stateSuccess.locations, event));
      }
    });

    // TODO: Use hydrated cubit
    setMap(AUMap.MIRA);
  }

  void setMap(AUMap map) async {
    List<MapLocation> locationsSingle = await _mapLocationRepository.getByMap(map);
    List<PathingEntry> pathingSingle = await _pathingRepository.getPathing();
    emit(MapLoadSuccess(map, locationsSingle, pathingSingle));
  }

  void addPathingEntry(PathingEntry pathingEntry) {
    _pathingRepository.addPathingEntry(pathingEntry);
  }

  @override
  Future<void> close() {
    _pathingSubscription?.cancel();
    return super.close();
  }
}
