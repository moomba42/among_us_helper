import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/predictions/model/predictions.dart";
import "package:bloc/bloc.dart";
import "package:meta/meta.dart";

part "predictions_state.dart";

/// Tracks the state of the user's predictions about the players.
class PredictionsCubit extends Cubit<PredictionsState> {
  PredictionsCubit() : super(PredictionsLoadSuccess(_buildDefaultPredictions()));

  /// Moves a player to a given section to the given position.
  /// Also makes sure that the player is not present in other sections.
  void move({@required Player player, @required PredictionsSection section, int newPosition = 0}) {
    PredictionsLoadSuccess successState = state;

    // Copy the original predictions
    Map<PredictionsSection, List<Player>> newPredictions =
        _duplicateMappedLists(successState.predictions);

    // Move the player to the desired section
    newPredictions.forEach((key, value) => value.remove(player));
    newPredictions[section].insert(newPosition, player);

    emit(PredictionsLoadSuccess(newPredictions));
  }

  /// Pushes a new state that has all players in the unknown section.
  void reset() {
    emit(PredictionsLoadSuccess(_buildDefaultPredictions()));
  }

  /// Builds a default predictions map, with each section added
  /// and with all players in the UNKNOWN section.
  static Map<PredictionsSection, List<Player>> _buildDefaultPredictions() {
    Map<PredictionsSection, List<Player>> initialData = Map.fromIterable(PredictionsSection.values,
        key: (section) => section, value: (section) => List<Player>.empty(growable: true));
    initialData[PredictionsSection.UNKNOWN].addAll(Player.values);
    return initialData;
  }

  /// Helper method which deep-duplicates the given mapped lists.
  /// Use this when you want to make sure updates to the lists
  /// in the new map won"t affect the original ones.
  static Map<K, List<T>> _duplicateMappedLists<K, T>(Map<K, List<T>> map) {
    return map.map((key, value) => MapEntry(key, List.of(value)));
  }
}
