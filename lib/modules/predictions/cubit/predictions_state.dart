part of "predictions_cubit.dart";

@immutable
abstract class PredictionsState {}

class PredictionsInitial extends PredictionsState {}

class PredictionsLoadSuccess extends PredictionsState {
  // TODO: Use Predictions type alias after dart adds the feature.
  final Map<PredictionsSection, List<Player>> predictions;
  final Map<Player, String> names;

  PredictionsLoadSuccess(this.predictions, this.names);
}
