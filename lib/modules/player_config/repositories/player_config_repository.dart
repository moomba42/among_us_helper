import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/model/player_config.dart";
import "package:rxdart/rxdart.dart";

class PlayerConfigRepository {
  // TODO: Replace with data store.
  /// Placeholder local cache.
  final BehaviorSubject<List<PlayerConfig>> _playerConfigs;

  PlayerConfigRepository()
      : this._playerConfigs = BehaviorSubject.seeded(Player.values
            .map(
              (Player player) => PlayerConfig(
                player: player,
                name: "",
                enabled: true,
              ),
            )
            .toList());

  Stream<List<PlayerConfig>> get playerConfigs => _playerConfigs.stream;

  void update(List<PlayerConfig> updatedConfigs) {
    List<PlayerConfig> newMap = [];

    // Duplicate current data into new map
    if (_playerConfigs.hasValue) {
      newMap.addAll(_playerConfigs.value);
    }

    // Remove duplicates
    newMap.removeWhere((PlayerConfig left) =>
        updatedConfigs.any((PlayerConfig right) => left.player == right.player));

    // Add new entries
    newMap.addAll(updatedConfigs);

    // Push changes
    _playerConfigs.add(newMap);
  }
}
