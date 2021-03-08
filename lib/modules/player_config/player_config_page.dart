import "package:among_us_helper/modules/player_config/cubit/player_config_cubit.dart";
import "package:among_us_helper/modules/player_config/player_config_view.dart";
import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PlayerConfigPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider<PlayerConfigCubit>(
        create: _createCubit,
        child: PlayerNamesView(),
      ),
    );
  }

  PlayerConfigCubit _createCubit(BuildContext context) {
    return PlayerConfigCubit(playerConfigRepository: context.read<PlayerConfigRepository>());
  }
}
