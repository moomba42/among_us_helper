import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/core/widgets/submit_button.dart";
import "package:among_us_helper/core/widgets/title_bar.dart";
import "package:among_us_helper/modules/player_names/cubit/player_names_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PlayerNamesView extends StatefulWidget {
  @override
  _PlayerNamesViewState createState() => _PlayerNamesViewState();
}

class _PlayerNamesViewState extends State<PlayerNamesView> {

  /// Internal padding of the list of player names.
  static const double _LIST_PADDING = 6;

  /// Height of the divider separating player name inputs.
  static const double _LIST_DIVIDER_HEIGHT = 1;

  /// We want to keep the element height at 48, so we take into account the divider height.
  static const double _LIST_ELEMENT_HEIGHT = 48 - _LIST_DIVIDER_HEIGHT;

  /// References for each player's name inputs.
  /// Used to set the field's values when a change in the cubit occurs.
  Map<Player, TextEditingController> _nameControllers;

  /// True if any input or checkbox has been changed.
  /// Used to disable the submit button.
  bool _formDirty;

  @override
  void initState() {
    _formDirty = false;
    _nameControllers = Map.fromIterable(
      Player.values,
      key: (player) => player,
      value: (player) => TextEditingController(),
    );

    PlayerNamesCubit boundCubit = context.read<PlayerNamesCubit>();
    boundCubit.listen(_applyStateToNameInputs);
    boundCubit.fetch();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Column(
        children: [
          TitleBar(
            title: "Players",
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 40,
              ),
              iconSize: 32,
              padding: EdgeInsets.all(0),
              onPressed: _onReturnPressed,
            ),
            actions: [
              IconButton(
                padding: EdgeInsets.all(0),
                icon: Icon(Icons.autorenew),
                onPressed: _onResetPressed,
              ),
            ],
          ),
          Expanded(
            child: _buildListView(context),
          ),
        ],
      ),
      Positioned(
        left: _LIST_PADDING * 2,
        right: _LIST_PADDING * 2,
        bottom: _LIST_PADDING * 2,
        child: SubmitButton(
          enabled: _formDirty,
          onPressed: _onSubmit,
          label: "Submit Names",
          leadingIcon: Icons.check_circle,
        ),
      )
    ]);
  }

  Widget _buildListView(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(_LIST_PADDING),
      itemCount: Player.values.length,
      separatorBuilder: (BuildContext context, int index) =>
          Divider(height: _LIST_DIVIDER_HEIGHT, indent: 69),
      itemBuilder: (BuildContext context, int index) {
        Player player = Player.values[index];
        return ListTile(
          title: SizedBox(
            height: _LIST_ELEMENT_HEIGHT,
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextFormField(
                controller: _nameControllers[player],
                onChanged: (String newValue) => _onPlayerNameInput(player, newValue),
                decoration: InputDecoration(
                  hintText: "Player $index",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          leading: _getImageForPlayer(player),
          trailing: Checkbox(
            value: true,
            onChanged: (bool newValue) {},
          ),
        );
      },
    );
  }

  /// Constructs a sized image [Widget] that represents an avatar for the given [player].
  /// The image name is deduced from the enumerated name.
  Widget _getImageForPlayer(Player player) {
    String name = player.toString().split(".")[1].toLowerCase();

    return SizedBox(
      height: _LIST_ELEMENT_HEIGHT * 3 / 4,
      width: _LIST_ELEMENT_HEIGHT * 3 / 4,
      child: Image(
          image: AssetImage("assets/players/$name.png"),
          isAntiAlias: true,
          filterQuality: FilterQuality.medium),
    );
  }

  /// Takes the given cubit [state] and overwrites an input's value if its different.
  /// This check is to prevent unnecessary widget rebuilds.
  void _applyStateToNameInputs(PlayerNamesState state) {
    if (state is! PlayerNamesLoadSuccess) {
      return;
    }

    PlayerNamesLoadSuccess stateSuccess = state;
    stateSuccess.playerNames.forEach((Player player, String name) {
      if (_nameControllers[player].text != name) {
        _nameControllers[player].text = name;
      }
    });
  }

  /// Handles the input event on a [player] name input.
  /// Marks the form as dirty if not marked already,
  /// and sends the [newValue] to the cubit.
  void _onPlayerNameInput(Player player, String newValue) {
    if (!_formDirty) {
      setState(() {
        _formDirty = true;
      });
    }
    context.read<PlayerNamesCubit>().change(player: player, name: newValue);
  }

  /// Handles the title bar's reset icon button press.
  /// Forwards the action to the cubit.
  void _onResetPressed() {
    context.read<PlayerNamesCubit>().reset();
  }

  /// Handles the title bar's back button press.
  /// Leaves this screen and goes back.
  void _onReturnPressed() {
    Navigator.of(context).pop();
  }

  /// Handles the submit button press.
  /// Forwards the action to the cubit, leaves this screen and goes back.
  void _onSubmit() {
    context.read<PlayerNamesCubit>().submit();
    Navigator.of(context).pop();
  }
}
