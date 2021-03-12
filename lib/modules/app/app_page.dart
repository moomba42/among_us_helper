import 'package:among_us_helper/modules/app/app_view_expanded.dart';
import "package:among_us_helper/modules/app/app_view_mobile.dart";
import "package:among_us_helper/modules/app/cubit/map_cubit.dart";
import "package:among_us_helper/modules/app/cubit/pathing_cubit.dart";
import "package:among_us_helper/modules/app/cubit/player_config_cubit.dart";
import "package:among_us_helper/modules/app/cubit/predictions_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class AppPage extends StatelessWidget {
  final ThemeData lightTheme = ThemeData(
      primarySwatch: Colors.blue,
      accentColor: Colors.blue,
      brightness: Brightness.light,
      textTheme: TextTheme(
          headline3: TextStyle(color: Colors.black87)
      )
  );

  final ThemeData darkTheme = ThemeData(
      primarySwatch: Colors.blue,
      accentColor: Colors.blue,
      brightness: Brightness.dark,
      textTheme: TextTheme(
          headline3: TextStyle(color: Colors.white)
      )
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: _buildBlocProviders(),
      child: MaterialApp(
        title: "Among Us Helper",
        theme: lightTheme,
        darkTheme: darkTheme,
        home: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            bool useExpandedView = constraints.maxWidth > 1400;
            return useExpandedView ? AppViewExpanded() : AppViewMobile();
          },
        ),
      ),
    );
  }

  List<BlocProvider> _buildBlocProviders() {
    return [
      BlocProvider<MapCubit>(create: (BuildContext context) => MapCubit()),
      BlocProvider<PathingCubit>(create: (BuildContext context) => PathingCubit()),
      BlocProvider<PlayerConfigCubit>(create: (BuildContext context) => PlayerConfigCubit()),
      BlocProvider<PredictionsCubit>(create: (BuildContext context) => PredictionsCubit()),
    ];
  }
}
