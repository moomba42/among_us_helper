import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:bloc/bloc.dart";
import "package:meta/meta.dart";

part "pathing_state.dart";

class PathingCubit extends Cubit<PathingState> {
  PathingCubit() : super(PathingLoadSuccess([]));

  void addEntry(PathingEntry entry) {
    PathingLoadSuccess stateSuccess = state;
    List<PathingEntry> updatedList = List.of(stateSuccess.pathing)..add(entry);
    PathingLoadSuccess newState = PathingLoadSuccess(updatedList);
    emit(newState);
  }

  void reset() {
    emit(PathingLoadSuccess([]));
  }
}
