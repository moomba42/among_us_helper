import "package:among_us_helper/core/icons.dart";
import "package:among_us_helper/modules/map/map_page.dart";
import "package:among_us_helper/modules/pathing/pathing_page.dart";
import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:among_us_helper/modules/predictions/predictions_page.dart";
import "package:among_us_helper/modules/predictions/repositories/predictions_repository.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

void main() {
  runApp(AmongUsHelperApp());
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
      )
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
          BottomNavigationBarItem(
              icon: Icon(CustomIcons.vector), label: "Pathing"),
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
    );
  }

  Widget _buildTabContent(BuildContext context) {
    switch(_selectedTab) {
      case 2: return PredictionsPage();
      case 1: return PathingPage();
      default: return MapPage();
    }
  }
}
