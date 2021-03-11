import "package:among_us_helper/modules/app/cubit/pathing_cubit.dart";
import "package:among_us_helper/modules/app/cubit/player_config_cubit.dart";
import "package:among_us_helper/modules/pathing/cubit/pathing_view_cubit.dart";
import "package:among_us_helper/modules/pathing/pathing_view.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PathingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider<PathingViewCubit>(
        create: _createCubit,
        child: PathingView(),
      ),
    );
  }

  PathingViewCubit _createCubit(BuildContext context) {
    return PathingViewCubit(
      pathingCubit: context.read<PathingCubit>(),
      playerConfigCubit: context.read<PlayerConfigCubit>(),
    );
  }
}
