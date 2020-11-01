import 'package:among_us_helper/icons.dart';
import 'package:among_us_helper/map_page.dart';
import 'package:among_us_helper/pathing_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AmongUsHelperApp());
}

class AmongUsHelperApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Among Us Helper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
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
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(CustomIcons.vector), label: 'Pathing'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: 'Notes'),
        ],
        currentIndex: _selectedTab,
        onTap: _onTabTapped,
        backgroundColor: Theme.of(context).primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ),
      backgroundColor: Theme.of(context).canvasColor,
      body: _selectedTab == 0 ? MapPage() : PathingPage(),
    );
  }
}
