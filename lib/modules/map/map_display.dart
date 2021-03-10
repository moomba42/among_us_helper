import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:among_us_helper/core/model/player.dart";
import "package:flutter/material.dart";

class MapDisplay extends StatefulWidget {
  final Widget mapImage;

  final List<PathingEntry> pathing;

  const MapDisplay({Key key, this.mapImage, this.pathing}) : super(key: key);

  @override
  _MapDisplayState createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  static const double PLAYER_SPACING = 10.0;
  static const double PLAYER_WIDTH = 60.0;
  static const double PLAYER_HEIGHT = 80.0;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      widget.mapImage,
      ...widget.pathing.map((e) => _buildPathingEntry(e)).toList(growable: false)
    ]);
  }

  Widget _buildPathingEntry(PathingEntry e) {
    List<Widget> entries = [];

    for (var player in e.players) {
      entries.add(
          Positioned(top: 0, left: entries.length * PLAYER_SPACING, child: _buildPlayer(player)));
    }

    double totalWidth = PLAYER_WIDTH + e.players.length * PLAYER_SPACING;

    // At least one non-positioned entry is needed to size the stack widget.
    // Otherwise its size will be (0,0).
    entries.add(SizedBox(width: totalWidth, height: PLAYER_HEIGHT));

    return Positioned(
      left: e.position.x - (totalWidth / 2),
      top: e.position.y - (PLAYER_HEIGHT / 2),
      child: Stack(
        children: entries,
      ),
    );
  }

  Widget _buildPlayer(Player player) {
    String playerName = player.getName();
    return SizedBox(
        width: PLAYER_WIDTH,
        height: PLAYER_HEIGHT,
        child: Image(
            image: AssetImage("assets/players/$playerName.png"),
            isAntiAlias: true,
            filterQuality: FilterQuality.high));
  }
}
