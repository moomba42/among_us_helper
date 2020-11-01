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
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text('Pathing', style: headline3),
        ),
        PathingItem(
          name: 'Brown',
          icon: Image(image: AssetImage("assets/players/brown.png")),
          color: Color(0xFF72491E),
          onMap: () {},
          pathing: Map.identity(),
        ),
        PathingItem(
          name: 'Red',
          icon: Image(image: AssetImage("assets/players/red.png")),
          color: Color(0xFFC51111),
          onMap: () {},
          pathing: Map.identity(),
        ),
      ],
    );
  }
}
