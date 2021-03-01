enum AUMap { SKELD, MIRA }

extension AUMapGetName on AUMap {
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
