import "dart:math";

import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/widgets/submit_button.dart";
import "package:among_us_helper/modules/player_config/repositories/player_config_repository.dart";
import "package:among_us_helper/modules/player_select/cubit/player_select_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PlayerSelect extends StatefulWidget {
  const PlayerSelect({Key key}) : super(key: key);

  @override
  _PlayerSelectState createState() => _PlayerSelectState();

  static Future<Set<Player>> showModal(BuildContext context) {
    return showModalBottomSheet<Set<Player>>(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      builder: (context) => BlocProvider<PlayerSelectCubit>(
          create: (BuildContext context) =>
              PlayerSelectCubit(playerConfigRepository: context.read<PlayerConfigRepository>()),
          child: PlayerSelect()),
    );
  }
}

class _PlayerSelectState extends State<PlayerSelect> {
  @override
  Widget build(BuildContext context) {
    var headlineStyle = Theme.of(context).textTheme.headline5;
    const contentSpacing = 16.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(contentSpacing, 8, contentSpacing, contentSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDragHandle(),
          SizedBox(height: contentSpacing),
          Text("Who was here?", style: headlineStyle),
          SizedBox(height: contentSpacing),
          Expanded(
            child: BlocBuilder<PlayerSelectCubit, PlayerSelectState>(
              builder: (BuildContext context, PlayerSelectState state) {
                if (state is! PlayerSelectLoadSuccess) {
                  return Text("Loading");
                }

                PlayerSelectLoadSuccess stateSuccess = state;
                Map<Player, bool> selection = stateSuccess.selection;

                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Calculate such column count, that the tiles reach the bottom.
                    int itemCount = selection.length;
                    double width = constraints.maxWidth;
                    double height = constraints.maxHeight;
                    double x = sqrt(width * height).ceilToDouble();
                    int columns =
                        (width / sqrt((x * x).ceilToDouble() / itemCount).ceilToDouble()).ceil();

                    return GridView.count(
                      primary: true,
                      shrinkWrap: true,
                      crossAxisCount: columns,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      children: selection.entries
                          .map((entry) => _buildPlayerOption(entry.key, entry.value, stateSuccess.names[entry.key]))
                          .toList(growable: false),
                    );
                  },
                );
              },
            ),
          ),
          BlocBuilder<PlayerSelectCubit, PlayerSelectState>(
            builder: (BuildContext context, PlayerSelectState state) {
              bool anythingSelected = false;

              if (state is PlayerSelectLoadSuccess) {
                anythingSelected = state.selection.values.contains(true);
              }

              return SubmitButton(
                onPressed: anythingSelected ? _onSubmit : null,
                label: "Confirm Positions",
                leadingIcon: Icons.check_circle,
              );
            },
          )
        ],
      ),
    );
  }

  void _onPlayerToggle(Player player) {
    setState(() {
      context.read<PlayerSelectCubit>().togglePlayer(player);
    });
  }

  void _onSubmit() {
    PlayerSelectState state = context.read<PlayerSelectCubit>().state;

    if (state is! PlayerSelectLoadSuccess) {
      Navigator.pop(context, []);
    }

    PlayerSelectLoadSuccess stateSuccess = state;
    Set<Player> selection =
        stateSuccess.selection.entries.where((element) => element.value).map((e) => e.key).toSet();
    Navigator.pop(context, selection);
  }

  Widget _buildPlayerOption(Player player, bool selected, String name) {
    var primaryColor = Theme.of(context).primaryColor;
    String enumeratedName = player.getNameLowercase();
    Color bgColor = player.getColor();
    bool isBright = bgColor.computeLuminance() > 0.5;
    Color textColor = isBright ? Colors.black87 : Colors.white;

    var button = ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(selected ? 4 : null),
          backgroundColor: MaterialStateProperty.all(player.getColor()),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          animationDuration: Duration(milliseconds: 200)),
      onPressed: () => _onPlayerToggle(player),
      child: Stack(children: [
        Positioned(
            left: -30,
            bottom: -60,
            right: 20,
            top: 40,
            child: Image(
                image: AssetImage("assets/players/$enumeratedName.png"),
                isAntiAlias: true,
                filterQuality: FilterQuality.high)),
        Container(
          constraints: BoxConstraints.expand(),
        ),
        Positioned(
            left: 16,
            top: 8,
            child: Text(name,
                style: Theme.of(context).textTheme.bodyText2.copyWith(color: textColor)))
      ]),
    );

    var decoration = ShapeDecoration(
        color: selected ? primaryColor.withOpacity(0.54) : primaryColor.withOpacity(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)));

    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.all(selected ? 6 : 0),
      decoration: decoration,
      child: button,
    );
  }

  Widget _buildDragHandle() {
    return Align(
      alignment: Alignment.center,
      child: Container(
          height: 3,
          width: 100,
          decoration: ShapeDecoration(
              color: Colors.black38,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)))),
    );
  }
}
