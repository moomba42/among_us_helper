import "dart:async";

import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/model/player_config.dart";
import "package:among_us_helper/modules/app/cubit/player_config_cubit.dart";
import "package:among_us_helper/modules/app/cubit/predictions_cubit.dart";
import "package:among_us_helper/modules/predictions/model/predictions.dart";
import "package:bloc/bloc.dart";
import "package:meta/meta.dart";
import "package:rxdart/rxdart.dart";

part "predictions_view_state.dart";

class PredictionsViewCubit extends Cubit<PredictionsViewState> {
  final PredictionsCubit _predictionsCubit;
  final PlayerConfigCubit _playerConfigCubit;

  StreamSubscription<PredictionsViewLoadSuccess> _stateSubscription;

  PredictionsViewCubit(
      {@required PredictionsCubit predictionsCubit, @required PlayerConfigCubit playerConfigCubit})
      : this._predictionsCubit = predictionsCubit,
        this._playerConfigCubit = playerConfigCubit,
        super(PredictionsViewInitial()) {
    // Map our input cubit states to ones that contain data.
    Stream<Map<PredictionsSection, List<Player>>> predictionsStream = _predictionsCubit
        .startWith(_predictionsCubit.state)
        .where((PredictionsState state) => state is PredictionsLoadSuccess)
        .map((PredictionsState state) => (state as PredictionsLoadSuccess).predictions);
    Stream<List<PlayerConfig>> configsStream = _playerConfigCubit
        .startWith(_playerConfigCubit.state)
        .where((PlayerConfigState state) => state is PlayerConfigLoadSuccess)
        .map((PlayerConfigState state) => (state as PlayerConfigLoadSuccess).config);

    // Wait for both streams to push data once and then update with every push.
    // Map that data to a state.
    Stream<PredictionsViewLoadSuccess> stateStream = Rx.combineLatest2(
      predictionsStream,
      configsStream,
      _mapInputDataToState,
    );

    // Every time we receive new mapped data, emit it.
    _stateSubscription = stateStream.listen(emit);
  }

  /// Maps the data received from the inputs to a success state,
  /// so that its easily accessible by the UI.
  PredictionsViewLoadSuccess _mapInputDataToState(
      Map<PredictionsSection, List<Player>> predictions, List<PlayerConfig> configs) {
    // Map names by the players in the config list.
    Map<Player, String> names = Map.fromIterable(
      configs,
      key: (config) => config.player,
      value: (config) => config.name,
    );

    // Map enables by the players in the config list.
    Map<Player, bool> enables = Map.fromIterable(
      configs,
      key: (config) => config.player,
      value: (config) => config.enabled,
    );

    // Return a new state using the mapped config fields.
    return PredictionsViewLoadSuccess.unmodifiable(predictions, names, enables);
  }

  /// Moves a [player] to a given [section] to the given [position].
  /// Delegates this to the [_predictionsCubit]
  void move({@required Player player, @required PredictionsSection section, int newPosition = 0}) {
    _predictionsCubit.move(
      player: player,
      section: section,
      newPosition: newPosition,
    );
  }

  /// Resets the state to a default one.
  /// Delegates this to the [_predictionsCubit]
  void reset() {
    _predictionsCubit.reset();
  }

  @override
  Future<void> close() {
    _stateSubscription?.cancel();
    return super.close();
  }
}
