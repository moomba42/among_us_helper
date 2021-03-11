import "package:among_us_helper/core/model/au_map.dart";
import "package:bloc/bloc.dart";
import "package:meta/meta.dart";

part "map_state.dart";

/// Handles the state of which map is currently selected.
class MapCubit extends Cubit<MapState> {
  MapCubit() : super(MapSelected(AUMap.MIRA));

  /// Changes the currently selected map.
  void changeSelection(AUMap newMap) {
    emit(MapSelected(newMap));
  }
}
