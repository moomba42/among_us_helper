part of "predictions_view_cubit.dart";

@immutable
abstract class PredictionsViewState {}

class PredictionsViewInitial extends PredictionsViewState {}

class PredictionsViewLoadSuccess extends PredictionsViewState {
  final Map<PredictionsSection, List<Player>> predictions;
  final Map<Player, String> names;
  final Map<Player, bool> enables;

  PredictionsViewLoadSuccess.unmodifiable(
    Map<PredictionsSection, List<Player>> predictions,
    Map<Player, String> names,
    Map<Player, bool> enables,
  )   : this.predictions = Map.unmodifiable(predictions.map(
            (PredictionsSection key, List<Player> value) =>
                MapEntry(key, List<Player>.unmodifiable(value)))),
        this.names = Map.unmodifiable(names),
        this.enables = Map.unmodifiable(enables);
}
