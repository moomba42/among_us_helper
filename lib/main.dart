import "package:among_us_helper/modules/app/app_page.dart";
import "package:among_us_helper/modules/pathing/repository/pathing_repository.dart";
import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:among_us_helper/modules/predictions/repositories/predictions_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:logging/logging.dart";

void main() {
  initializeLogging();
  runApp(AmongUsHelperApp());
}

void initializeLogging() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print("${record.level.name}: ${record.time}: ${record.message}");
  });
}

class AmongUsHelperApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: _getRepositoryProviders(),
      child: MaterialApp(
        title: "Among Us Helper",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AppPage(),
      ),
    );
  }

  /// Builds a list of repositories to inject into the app
  List<RepositoryProvider> _getRepositoryProviders() {
    return [
      RepositoryProvider<PredictionsRepository>(
        create: (BuildContext context) => PredictionsRepository(),
      ),
      RepositoryProvider<PlayerConfigRepository>(
        create: (BuildContext context) => PlayerConfigRepository(),
      ),
      RepositoryProvider<PathingRepository>(
        create: (BuildContext context) => PathingRepository(),
      ),
    ];
  }
}
