import "dart:ui";

import "package:among_us_helper/core/model/au_map.dart";
import "package:flutter/foundation.dart";

/// Metadata for AmongUs maps. Used to annotate player pathing locations.
class MapLocation {
  /// Which map this location belongs to. Used to retrieve the correct locations for a map.
  final AUMap map;

  /// Bounds of this location on the map, relative to the map bounds.
  /// Used to calculate if the user clicked the given location.
  final List<Rect> bounds;

  /// Name of this location on the map. F.ex. Cafeteria
  final String name;

  MapLocation({@required this.map, @required this.bounds, @required this.name,});
}
