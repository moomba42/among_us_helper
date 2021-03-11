part of "pathing_cubit.dart";

@immutable
abstract class PathingState {}

class PathingLoadSuccess extends PathingState {
  final List<PathingEntry> pathing;

  PathingLoadSuccess(List<PathingEntry> pathing) : this.pathing = List<PathingEntry>.unmodifiable(pathing);
}
