import "package:among_us_helper/modules/pathing/cubit/pathing_cubit.dart";
import "package:among_us_helper/modules/pathing/pathing_view.dart";
import "package:among_us_helper/modules/pathing/repository/pathing_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PathingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider<PathingCubit>(
        create: _createCubit,
        child: PathingView(),
      ),
    );
  }

  PathingCubit _createCubit(BuildContext context) {
    return PathingCubit(
      pathingRepository: context.read<PathingRepository>(),
    );
  }
}
