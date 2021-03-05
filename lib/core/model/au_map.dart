/// Enumerates all supported AmongUs maps.
enum AUMap { SKELD, MIRA }

extension AUMapGetName on AUMap {
  String getName() {
    switch (this) {
      case AUMap.SKELD:
        return 'The Skeld';
      case AUMap.MIRA:
        return 'Mira';
      default:
        return null;
    }
  }
}

extension AUMapGetSvgAsset on AUMap {
  String getSvgAsset() {
    switch (this) {
      case AUMap.SKELD:
        return 'assets/maps/skeld.svg';
      case AUMap.MIRA:
        return 'assets/maps/mira.svg';
      default:
        return null;
    }
  }
}
