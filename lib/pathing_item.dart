import 'dart:math';

import 'package:flutter/material.dart';

class PathingItem extends StatelessWidget {
  final String name;
  final Widget icon;
  final Color color;
  final Function onMap;
  final Map<String, int> pathing;

  const PathingItem({Key key, this.name, this.icon, this.color, this.onMap, this.pathing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black,
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: SizedBox(height: 40, child: icon),
        title: Text(name, style: TextStyle(color: Colors.white)),
        tileColor: color,
        trailing: Transform.rotate(angle: 90 * pi / 180,
          child: Icon(Icons.chevron_right, color: Colors.white)),
      ),
    );
  }
}
