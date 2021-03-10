part of "pathing_cubit.dart";

@immutable
abstract class PathingState {}

class PathingInitial extends PathingState {}

class PathingLoadSuccess extends PathingState {
  final Map<Player, List<PathingEntry>> pathing;

  PathingLoadSuccess(this.pathing);
}