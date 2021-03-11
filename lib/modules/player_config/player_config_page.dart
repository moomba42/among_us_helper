import "package:among_us_helper/modules/app/cubit/player_config_cubit.dart";
import "package:among_us_helper/modules/player_config/cubit/player_config_view_cubit.dart";
import "package:among_us_helper/modules/player_config/player_config_view.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PlayerConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider<PlayerConfigViewCubit>(
        create: _createCubit,
        child: PlayerNamesView(),
      ),
    );
  }

  PlayerConfigViewCubit _createCubit(BuildContext context) {
    return PlayerConfigViewCubit(
      playerConfigCubit: context.read<PlayerConfigCubit>(),
    );
  }
}
