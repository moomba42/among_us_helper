import "package:among_us_helper/modules/app/cubit/player_config_cubit.dart";
import "package:among_us_helper/modules/app/cubit/predictions_cubit.dart";
import "package:among_us_helper/modules/predictions/cubit/predictions_view_cubit.dart";
import "package:among_us_helper/modules/predictions/predictions_view.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PredictionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider<PredictionsViewCubit>(
        create: _createCubit,
        child: PredictionsView(),
      ),
    );
  }

  PredictionsViewCubit _createCubit(BuildContext context) {
    return PredictionsViewCubit(
      predictionsCubit: context.read<PredictionsCubit>(),
      playerConfigCubit: context.read<PlayerConfigCubit>(),
    );
  }
}
