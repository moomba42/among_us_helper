import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/predictions/model/predictions.dart";
import "package:rxdart/subjects.dart";

class PredictionsRepository {
  // TODO: Replace with data store.
  /// Placeholder local cache.
  final BehaviorSubject<Map<PredictionsSection, List<Player>>> _predictions;

  PredictionsRepository()
      : this._predictions = BehaviorSubject.seeded(_generateInitialPredictions());

  Stream<Map<PredictionsSection, List<Player>>> get predictionsMap => _predictions.stream;

  void update(Map<PredictionsSection, List<Player>> updatedPredictions) {
    Map<PredictionsSection, List<Player>> newMap = Map.identity();

    // Duplicate current data into new map
    if (_predictions.valueWrapper != null) {
      newMap.addAll(_predictions.valueWrapper.value);
    }

    // Overwrite
    newMap.addAll(updatedPredictions);

    // Push changes
    _predictions.add(newMap);
  }

  void reset() {
    _predictions.add(_generateInitialPredictions());
  }

  /// Generates an initial state of predictions.
  static Map<PredictionsSection, List<Player>> _generateInitialPredictions() {
    Map<PredictionsSection, List<Player>> initialData = Map.fromIterable(PredictionsSection.values,
        key: (section) => section, value: (section) => []);
    initialData[PredictionsSection.UNKNOWN].addAll(Player.values);
    return initialData;
  }
}
