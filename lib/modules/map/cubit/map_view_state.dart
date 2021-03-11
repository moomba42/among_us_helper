part of "map_view_cubit.dart";

@immutable
abstract class MapViewState {}

class MapViewInitial extends MapViewState {}

class MapViewLoadSuccess extends MapViewState {
  final AUMap map;
  final List<PathingEntry> pathing;

  MapViewLoadSuccess(this.map, this.pathing);
}
