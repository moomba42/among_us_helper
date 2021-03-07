import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:among_us_helper/modules/predictions/cubit/predictions_cubit.dart";
import "package:among_us_helper/modules/predictions/predictions_view.dart";
import "package:among_us_helper/modules/predictions/repositories/predictions_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PredictionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => PredictionsCubit(
              predictionsRepository: context.read<PredictionsRepository>(),
              playerNamesRepository: context.read<PlayerConfigRepository>(),
            ),
        child: PredictionsView());
  }
}
