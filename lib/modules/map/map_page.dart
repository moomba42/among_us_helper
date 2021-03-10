import "package:among_us_helper/modules/map/cubit/map_cubit.dart";
import "package:among_us_helper/modules/map/map_select_overlay.dart";
import "package:among_us_helper/modules/map/map_view.dart";
import "package:among_us_helper/modules/pathing/repository/pathing_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider<MapCubit>(
        create: _createCubit,
        child: MapSelectOverlay(
          body: MapView(),
        ),
      ),
    );
  }

  MapCubit _createCubit(BuildContext context) {
    return MapCubit(
      pathingRepository: context.read<PathingRepository>(),
    );
  }
}
