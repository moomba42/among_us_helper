part of "pathing_view_cubit.dart";

@immutable
abstract class PathingViewState {}

class PathingViewInitial extends PathingViewState {}

class PathingViewLoadSuccess extends PathingViewState {
  final Map<Player, List<PathingEntry>> pathing;
  final Map<Player, String> names;

  PathingViewLoadSuccess(this.pathing, this.names);
}
