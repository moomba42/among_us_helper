import "dart:math";

import "package:among_us_helper/core/model/map_location.dart";
import "package:among_us_helper/core/model/player.dart";
import "package:flutter/foundation.dart";

class PathingEntry {
  /// The map location that the [position] is located in.
  final MapLocation location;

  /// The exact position of where the players have been on the map.
  final Point<double> position;

  /// When this pathing entry was created.
  final int time;

  /// Set of players that were at the location.
  final Set<Player> players;

  PathingEntry({
    @required this.location,
    @required this.position,
    @required this.time,
    @required this.players,
  });
}
