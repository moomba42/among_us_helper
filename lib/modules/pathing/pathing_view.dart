import "package:among_us_helper/core/model/pathing_entry.dart";
import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/widgets/title_bar.dart";
import "package:among_us_helper/modules/pathing/cubit/pathing_cubit.dart";
import "package:among_us_helper/modules/pathing/pathing_item.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PathingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleBar(
          title: "Pathing",
        ),
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: _buildEntries(context),
        )
      ],
    );
  }

  Widget _buildEntries(BuildContext context) {
    return BlocBuilder<PathingCubit, PathingState>(
      builder: (BuildContext context, PathingState state) {
        if (state is! PathingLoadSuccess) {
          return _buildNoEntries();
        }

        PathingLoadSuccess stateSuccess = state;

        if (stateSuccess.pathing.isEmpty) {
          return _buildNoEntries();
        }

        List<Widget> items =
            stateSuccess.pathing.entries.map((MapEntry<Player, List<PathingEntry>> mapEntry) {
          Player player = mapEntry.key;
          String playerName = player.getNameLowercase();
          List<PathingEntry> entries = mapEntry.value;
          return PathingTile(
            label: _textOrPlayerName(stateSuccess.names[player], player),
            icon: Image(
                image: AssetImage("assets/players/$playerName.png"),
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
    return player.getCamelName();
  }

  Widget _buildNoEntries() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [Text("No entries. Go to the map!")],
    );
  }
}
