import "package:among_us_helper/modules/app/cubit/map_cubit.dart";
import "package:among_us_helper/modules/app/cubit/pathing_cubit.dart";
import "package:among_us_helper/modules/map/cubit/map_view_cubit.dart";
import "package:among_us_helper/modules/map/map_select_overlay.dart";
import "package:among_us_helper/modules/map/map_view.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocProvider<MapViewCubit>(
        create: _createCubit,
        child: MapSelectOverlay(
          body: MapView(),
        ),
      ),
    );
  }

  MapViewCubit _createCubit(BuildContext context) {
    return MapViewCubit(
      mapCubit: context.read<MapCubit>(),
      pathingCubit: context.read<PathingCubit>(),
    );
  }
}
