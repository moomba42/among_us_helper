import "package:among_us_helper/modules/player_names/cubit/player_names_cubit.dart";
import "package:among_us_helper/modules/player_names/player_names_view.dart";
import "package:among_us_helper/modules/player_names/repositories/player_names_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PlayerNamesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider(
          create: (BuildContext context) =>
              PlayerNamesCubit(playerNamesRepository: context.read<PlayerNamesRepository>()),
          child: PlayerNamesView()),
    );
  }
}
