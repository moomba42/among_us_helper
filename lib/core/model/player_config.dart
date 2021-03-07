import "package:among_us_helper/core/model/player.dart";

class PlayerConfig {
  final Player player;
  final String name;
  final bool enabled;

  PlayerConfig(this.player, this.name, this.enabled);

  // TODO: Use the new player config enabled field to disable dragging widgets of players.
  // TODO: Make checkboxes in player config view work and update the repo.
}
