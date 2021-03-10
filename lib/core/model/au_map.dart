import 'dart:ui';

import "package:among_us_helper/core/model/map_location.dart";

/// Enumerates all supported AmongUs maps.
enum AUMap { SKELD, MIRA }

extension AUMapGetName on AUMap {
  String getName() {
    switch (this) {
      case AUMap.SKELD:
        return "The Skeld";
      case AUMap.MIRA:
        return "Mira";
      default:
        return null;
    }
  }
}

extension AUMapGetSvgAsset on AUMap {
  String getSvgAsset() {
    switch (this) {
      case AUMap.SKELD:
        return "assets/maps/skeld.svg";
      case AUMap.MIRA:
        return "assets/maps/mira.svg";
      default:
        return null;
    }
  }
}

extension AUMapGetLocations on AUMap {
  List<MapLocation> getLocations() {
    switch (this) {
      case AUMap.SKELD:
        return [
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(190.5, 845.5, 378, 703)],
            name: "Reactor",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(539.5, 445, 407.5, 450.5)],
            name: "Upper Engine",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(539.5, 1526.5, 407.5, 452.5)],
            name: "Lower Engine",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(981.5, 935.5, 225.5, 465)],
            name: "Security",
          ),
          MapLocation(
            map: this,
            bounds: [
              Rect.fromLTWH(1274, 785, 365, 482),
              Rect.fromLTWH(1644, 1004, 82, 263),
              Rect.fromLTWH(1711, 1069, 82, 198),
            ],
            name: "MedBay",
          ),
          MapLocation(
            map: this,
            bounds: [
              Rect.fromLTWH(2744, 906, 184, 301),
              Rect.fromLTWH(2607, 1077, 137, 130),
              Rect.fromLTWH(2607, 1009, 137, 67),
              Rect.fromLTWH(2667, 941, 77, 88),
            ],
            name: "O2",
          ),
          MapLocation(
            map: this,
            bounds: [
              Rect.fromLTWH(1704, 171, 973, 765),
              Rect.fromLTWH(1918, 925, 544, 222),
              Rect.fromLTWH(1801, 925, 118, 222),
              Rect.fromLTWH(1704, 925, 215, 131),
              Rect.fromLTWH(2447, 925, 148, 222),
              Rect.fromLTWH(2532, 925, 119, 101),
              Rect.fromLTWH(2607, 926, 71, 66),
            ],
            name: "Cafeteria",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(2866, 374, 398.5, 457.5)],
            name: "Weapons",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(3612.5, 941.5, 308, 404)],
            name: "Navigation",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(1352, 1363, 441, 553)],
            name: "Electrical",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(1801, 1486, 527.5, 804.5)],
            name: "Storage",
          ),
          MapLocation(
            map: this,
            bounds: [
              Rect.fromLTWH(2254, 1273, 602, 160),
              Rect.fromLTWH(2420, 1273, 436, 388),
            ],
            name: "Admin",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(2381.5, 1881.5, 435.5, 403.5)],
            name: "Comms",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(2868, 1604.5, 399, 458)],
            name: "Shields",
          ),
        ];
      case AUMap.MIRA:
        return [
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(271, 1797, 346.5, 342.5)],
            name: "Launchpad",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(817.5, 804.5, 387.5, 560.5)],
            name: "Reactor",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(1205, 1375, 178, 526.5)],
            name: "Decontamination",
          ),
          MapLocation(
            map: this,
            bounds: [
              Rect.fromLTWH(1113.5, 1901.5, 586, 214),
              Rect.fromLTWH(1472, 1641.5, 226, 474.5),
            ],
            name: "Locker Room",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(1383, 920.5, 385, 444.5)],
            name: "Laboratory",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(1829, 117.98, 785, 291.02)],
            name: "Greenhouse",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(1829, 409, 300, 393)],
            name: "Office",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(2312, 409, 302, 393)],
            name: "Admin",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(1884.5, 1641.5, 277, 292.5)],
            name: "Comms",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(1884.5, 1942.5, 277, 361.5)],
            name: "MedBay",
          ),
          MapLocation(
            map: this,
            bounds: [Rect.fromLTWH(2231.5, 1641.5, 243.5, 368)],
            name: "Storage",
          ),
          MapLocation(
            map: this,
            bounds: [
              Rect.fromLTWH(2231.5, 2010, 882, 162),
              Rect.fromLTWH(2486, 1642, 628, 368),
            ],
            name: "Cafeteria",
          ),
          MapLocation(
            map: this,
            bounds: [
              Rect.fromLTWH(2231.5, 2171.5, 882, 173),
              Rect.fromLTWH(2232, 2345, 186, 79),
            ],
            name: "Balcony",
          ),
        ];
      default:
        return null;
    }
  }
}
