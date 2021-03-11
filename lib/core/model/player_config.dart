import "package:among_us_helper/core/model/player.dart";
import "package:flutter/material.dart";

@immutable
class PlayerConfig {
  final Player player;
  final String name;
  final bool enabled;

  PlayerConfig({
    @required this.player,
    @required this.name,
    @required this.enabled,
  });
}
