import 'package:among_us_helper/pathing_item.dart';
import 'package:flutter/material.dart';

class PathingPage extends StatefulWidget {
  @override
  _PathingPageState createState() => _PathingPageState();
}

class _PathingPageState extends State<PathingPage> {


  @override
  Widget build(BuildContext context) {
    var headline3 = Theme.of(context).textTheme.headline3.copyWith(color: Colors.black87);

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text('Pathing', style: headline3),
          ),
          PathingTile(
            label: 'Brown',
            icon: Image(image: AssetImage("assets/players/brown.png"), isAntiAlias: true, filterQuality: FilterQuality.high,),
            tileColor: Color(0xFF72491E),
            onMapPressed: () {},
            pathing: {
              "Cafeteria": 13400,
              "Navigation": 20552,
              "Storage": 551442,
              "Security": 761203
            },
          ),
          PathingTile(
            label: 'Red',
            icon: Image(image: AssetImage("assets/players/red.png"), isAntiAlias: true, filterQuality: FilterQuality.high),
            tileColor: Color(0xFFC51111),
            onMapPressed: () {},
            pathing: Map.identity(),
          ),
          PathingTile(
            label: 'White',
            icon: Image(image: AssetImage("assets/players/white.png"), isAntiAlias: true, filterQuality: FilterQuality.high),
            tileColor: Colors.white,
            onMapPressed: () {},
            pathing: {
              "Cafeteria": 13400,
              "Navigation": 20552,
              "Storage": 551442,
              "Security": 761203
            },
          ),
        ],
      ),
    );
  }
}
