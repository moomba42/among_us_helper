enum AUMap {
  SKELD,
  POLUS,
  MIRA
}

extension AUMapName on AUMap {
  String getName() {
    switch(this) {
      case AUMap.SKELD:
        return 'The Skeld';
      case AUMap.POLUS:
        return 'Polus';
      case AUMap.MIRA:
        return 'Mira';
    }
  }
}
