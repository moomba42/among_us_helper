import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/pathing/cubit/pathing_cubit.dart";
import "package:among_us_helper/modules/pathing/pathing_item.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PathingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var headline3 = Theme.of(context).textTheme.headline3.copyWith(color: Colors.black87);

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text("Pathing", style: headline3),
          ),
          _buildEntries(context),
        ],
      ),
    );
  }

  Widget _buildEntries(BuildContext context) {
    return BlocBuilder<PathingCubit, PathingState>(
      builder: (BuildContext context, PathingState state) {
        if (state is! PathingLoadSuccess) {
          return Text("No entries");
        }

        PathingLoadSuccess stateSuccess = state;

        List<Widget> items =
            stateSuccess.pathing.entries.map((MapEntry<Player, List<PathingEntry>> mapEntry) {
          Player player = mapEntry.key;
          String name = player.toString().split(".")[1].toLowerCase();
          List<PathingEntry> entries = mapEntry.value;
          return PathingTile(
            label: _textOrPlayerName(stateSuccess.names[player], player),
            icon: Image(
                image: AssetImage("assets/players/$name.png"),
                isAntiAlias: true,
                filterQuality: FilterQuality.high),
            tileColor: player.getColor(),
            pathing: Map<String, int>.fromIterable(entries,
                key: (entry) => entry.location?.name ?? "Unknown", value: (entry) => entry.time),
          );
        }).toList();

        return Column(
          children: items,
        );
      },
    );
  }

  // TODO: Remove duplicate code
  String _textOrPlayerName(String name, Player player) {
    if (name != null && name.isNotEmpty) {
      return name;
    }

    String playerName = player.toString().split(".")[1].toLowerCase();
    String camelName = playerName.substring(0, 1).toUpperCase() + playerName.substring(1);

    return camelName;
  }
}
