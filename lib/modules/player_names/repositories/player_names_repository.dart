import "package:among_us_helper/core/model/player.dart";
import "package:rxdart/subjects.dart";

class PlayerNamesRepository {
  // TODO: Replace with data store.
  /// Placeholder local cache.
  final BehaviorSubject<Map<Player, String>> _playerNames;

  PlayerNamesRepository()
      : this._playerNames = BehaviorSubject.seeded(
            Map.fromIterable(Player.values, key: (player) => player, value: (player) => ""));

  Stream<Map<Player, String>> get playerNames => _playerNames.stream;

  void update(Map<Player, String> updatedNames) {
    Map<Player, String> newMap = Map.identity();

    // Duplicate current data into new map
    if (_playerNames.valueWrapper != null) {
      newMap.addAll(_playerNames.valueWrapper.value);
    }

    // Overwrite
    newMap.addAll(updatedNames);

    // Push changes
    _playerNames.add(newMap);
  }
}
