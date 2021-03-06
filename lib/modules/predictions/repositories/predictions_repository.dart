import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/predictions/model/predictions.dart";
import "package:rxdart/subjects.dart";

class PredictionsRepository {
  // TODO: Replace with data store.
  /// Placeholder local cache.
  final BehaviorSubject<Map<PredictionsSection, List<Player>>> _predictions;

  PredictionsRepository(): this._predictions = new BehaviorSubject();

  Stream<Map<PredictionsSection, List<Player>>> predictionsMap() => _predictions.stream;

  void update(Map<PredictionsSection, List<Player>> updatedPredictions) {
    // Duplicate
    Map<PredictionsSection, List<Player>> duplicate = Map.of(_predictions.valueWrapper.value);

    // Overwrite
    duplicate.addAll(updatedPredictions);

    // Push changes
    _predictions.add(duplicate);
  }
}
