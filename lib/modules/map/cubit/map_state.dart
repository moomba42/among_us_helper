part of "map_cubit.dart";

@immutable
abstract class MapState {}

class MapInitial extends MapState {}

class MapLoadSuccess extends MapState {
  final AUMap map;
  final List<MapLocation> locations;
  final List<PathingEntry> pathing;

  MapLoadSuccess(this.map, this.locations, this.pathing);
}
