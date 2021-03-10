import "package:among_us_helper/core/icons.dart";
import "package:among_us_helper/core/widgets/confirmation_dialog.dart";
import "package:among_us_helper/modules/map/map_page.dart";
import "package:among_us_helper/modules/pathing/pathing_page.dart";
import "package:among_us_helper/modules/pathing/repository/pathing_repository.dart";
import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:among_us_helper/modules/predictions/predictions_page.dart";
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
        home: MainPage(),
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

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedTab = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(CustomIcons.vector), label: "Pathing"),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Notes"),
        ],
        currentIndex: _selectedTab,
        onTap: _onTabTapped,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: _buildTabContent(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startNewRound,
        label: Text("NEW ROUND"),
        icon: Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildTabContent(BuildContext context) {
    switch (_selectedTab) {
      case 2:
        return PredictionsPage();
      case 1:
        return PathingPage();
      default:
        return MapPage();
    }
  }

  /// Resets pathing and predictions to let the player start a new round.
  void _startNewRound() {
    ConfirmationDialog.showConfirmationDialog(
      context: context,
      title: Text("Starting new round"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("This will reset the pathing information & predictions."),
          Text("Player names will be preserved."),
          SizedBox(height: 8),
          Text("Are you sure you want to continue?"),
        ],
      ),
    ).then((Confirmation confirmation) {
      if (confirmation != Confirmation.ACCEPTED) {
        return;
      }

      context.read<PathingRepository>().reset();
      context.read<PredictionsRepository>().reset();
    });
  }
}
