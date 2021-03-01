enum AUMap { SKELD, MIRA }

extension AUMapName on AUMap {
  String getName() {
    switch (this) {
      case AUMap.SKELD:
        return 'The Skeld';
      case AUMap.MIRA:
        return 'Mira';
      default:
        return 'Unknown';
    }
  }
}
