import "dart:async";

import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/pathing/repository/pathing_repository.dart";
import "package:bloc/bloc.dart";
import "package:logging/logging.dart";
import "package:meta/meta.dart";

part "pathing_state.dart";

class PathingCubit extends Cubit<PathingState> {
  final Logger _logger = Logger("PathingCubit");
  final PathingRepository _pathingRepository;

  StreamSubscription<List<PathingEntry>> _pathingSubscription;

  PathingCubit({@required PathingRepository pathingRepository})
      : this._pathingRepository = pathingRepository,
        super(PathingInitial()) {
    Stream<List<PathingEntry>> pathingEntryStream = _pathingRepository.pathing;
    _pathingSubscription = pathingEntryStream.listen((List<PathingEntry> event) {
      Map<Player, List<PathingEntry>> grouped = {};
      event.forEach(
        (PathingEntry entry) => entry.players.forEach(
          (Player player) => grouped.putIfAbsent(player, () => []).add(entry),
        ),
      );
      emit(PathingLoadSuccess(grouped));
    });
  }

  @override
  Future<void> close() {
    _pathingSubscription?.cancel();
    return super.close();
  }
}
