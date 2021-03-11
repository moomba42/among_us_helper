part of "predictions_cubit.dart";

@immutable
abstract class PredictionsState {}

class PredictionsLoadSuccess extends PredictionsState {
  final Map<PredictionsSection, List<Player>> predictions;

  PredictionsLoadSuccess(Map<PredictionsSection, List<Player>> predictions)
      : this.predictions = Map.unmodifiable(predictions.map(
          (section, value) => MapEntry(section, List<Player>.unmodifiable(value)),
        ));
}
