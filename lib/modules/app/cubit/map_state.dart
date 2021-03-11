part of "map_cubit.dart";

@immutable
abstract class MapState {}

class MapSelected extends MapState {
  final AUMap selectedMap;

  MapSelected(this.selectedMap);
}
