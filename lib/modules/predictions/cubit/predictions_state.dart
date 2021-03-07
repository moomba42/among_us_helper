part of "predictions_cubit.dart";

@immutable
abstract class PredictionsState {}

class PredictionsInitial extends PredictionsState {}

class PredictionsLoadSuccess extends PredictionsState {
  // TODO: Use Predictions type alias after dart adds the feature.
  final Map<PredictionsSection, List<Player>> predictions;
  final Map<Player, String> names;
  final Map<Player, bool> enables;

  PredictionsLoadSuccess.unmodifiable(
    Map<PredictionsSection, List<Player>> predictions,
    Map<Player, String> names,
    Map<Player, bool> enables,
  )   : this.predictions = Map.unmodifiable(predictions.map(
            (PredictionsSection key, List<Player> value) =>
                MapEntry(key, List<Player>.unmodifiable(value)))),
        this.names = Map.unmodifiable(names),
        this.enables = Map.unmodifiable(enables);
}
