import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:rxdart/rxdart.dart";

class PathingRepository {

  final BehaviorSubject<List<PathingEntry>> _pathing;

  PathingRepository(): this._pathing = BehaviorSubject.seeded([]);

  Stream<List<PathingEntry>> get pathing => _pathing.stream;

  void addPathingEntry(PathingEntry entry) {
    _pathing.add(_pathing.valueWrapper.value..add(entry));
  }

  Future<List<PathingEntry>> getPathing() {
    return Future.value(_pathing.value);
  }
}
