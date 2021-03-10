import "dart:io";

import "package:among_us_helper/core/model/player.dart";
import "package:among_us_helper/modules/predictions/cubit/predictions_cubit.dart";
import "package:among_us_helper/modules/predictions/model/predictions.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:logging/logging.dart";
import "package:flutter_reorderable_list/flutter_reorderable_list.dart" as ROL;

class PredictionsList extends StatefulWidget {
  @override
  _PredictionsListState createState() => _PredictionsListState();
}

class _PredictionsListState extends State<PredictionsList> {
  final Logger _logger = new Logger("_PredictionsListState");
  final double _LIST_SPACING = 8;

  /// Cached status of loading progress of the predictions cubit.
  bool _isLoading = true;

  /// Local reflection of the cubit loaded state. We need a duplicate here because we don't want
  /// to send out updates while the user is dragging a player around, which requires modification
  /// of the map to position the placeholder correctly.
  Map<PredictionsSection, List<Player>> _predictionsMap;

  @override
  Widget build(BuildContext context) {
    // If we are still loading, show a spinning loader and listen for changes to the state.
    if (_isLoading) {
      return BlocListener<PredictionsCubit, PredictionsState>(
        listener: _onNewCubitState,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Data is present and we can show the predictions list.
    // Push changes to the cubit if user changes the predictions order,
    // and also listen for any changes that may come.
    return ROL.ReorderableList(
      decoratePlaceholder: _withEmptyDecoration,
      onReorderDone: _onListReorderDone,
      onReorder: _onListReorder,
      child: BlocListener<PredictionsCubit, PredictionsState>(
        listener: _onNewCubitState,
        child: _buildList(context),
      ),
    );
  }

  /// Builds an empty decoration for a [widget] placeholder.
  /// We don't want to show any shadows rendered using this decoration,
  /// because they are already rendered using the [_Entry] widget.
  /// The [opacity] argument is not used.
  ROL.DecoratedPlaceholder _withEmptyDecoration(Widget widget, double opacity) {
    return ROL.DecoratedPlaceholder(offset: 0, widget: widget);
  }

  /// Verifies that the [key] of the dragged widget is indeed a Player, and if so,
  /// calls a method to submit any changes made to that Player.
  void _onListReorderDone(Key key) {
    if (key is ValueKey && key.value is Player) {
      _submitPredictionChange(key.value as Player);
    }
  }

  /// Gets the current position of the given [player],
  /// and submits that information to the [PredictionsCubit].
  void _submitPredictionChange(Player player) {
    _EntryPosition entryPosition = _getEntryPositionByPlayer(player);
    context.read<PredictionsCubit>().move(
          player: player,
          section: entryPosition.section,
          newPosition: entryPosition.index,
        );
  }

  /// Determines where the [dragged] player is being dragged over ([target]),
  /// and inserts the player into that location,
  /// such that the resulting placeholder is located under the [dragged] player widget.
  ///
  /// The returned [bool] value is `true` if the dragged over element should animate out of the way.
  bool _onListReorder(Key dragged, Key target) {
    // If either key is not a value key,
    // then we will not be able to determine which widget is affected.
    if (dragged is! ValueKey || target is! ValueKey) {
      return false;
    }

    ValueKey draggedValueKey = dragged;
    ValueKey targetValueKey = target;

    // We only allow for dragging players, so abort if the dragged widget has a different key.
    if (draggedValueKey.value is! Player) {
      return false;
    }

    // Get the position of the dragged player in the predictions map.
    Player draggedPlayer = draggedValueKey.value;
    _EntryPosition draggedPlayerPosition = _getEntryPositionByPlayer(draggedPlayer);

    // Determine where the dragged player should be inserted.
    // If the target is a section, then position the dragged player right under it,
    // without animating the section.
    if (targetValueKey.value is PredictionsSection) {
      // Since we already have the section name, we dont have to do complex logic here.
      // The first position under the section will always be the start of the list, which is 0.
      _EntryPosition targetPosition = _EntryPosition(section: targetValueKey.value, index: 0);

      // Set our state to update the UI (without updating the cubit yet).
      setState(() {
        _predictionsMap[draggedPlayerPosition.section].remove(draggedPlayer);
        _predictionsMap[targetPosition.section].insert(targetPosition.index, draggedPlayer);
      });

      return false;
    }
    // If the target is a Player, then get its position and section,
    // then position the dragged player right under it,
    // and animate the target Player out of the way.
    else if (targetValueKey.value is Player) {
      Player targetPlayer = targetValueKey.value;
      _EntryPosition targetPosition = _getEntryPositionByPlayer(targetPlayer);

      // Set our state to update the UI (without updating the cubit yet).
      setState(() {
        _predictionsMap[draggedPlayerPosition.section].remove(draggedPlayer);
        _predictionsMap[targetPosition.section].insert(targetPosition.index, draggedPlayer);
      });

      return true;
    }

    _logger.warning("Could not recognize target ValueKey value.");
    return false;
  }

  /// Determines where the given [player] is located within the predictions list.
  /// Returns the section and index in that section's player list
  /// that the given [player] is located in.
  _EntryPosition _getEntryPositionByPlayer(Player player) {
    // First section that contains the given player.
    MapEntry<PredictionsSection, List<Player>> sectionEntry =
        _predictionsMap.entries.firstWhere((element) => element.value.contains(player));

    PredictionsSection section = sectionEntry.key;

    // Index of the given player in that section's list.
    int index = sectionEntry.value.indexOf(player);

    return _EntryPosition(section: section, index: index);
  }

  /// Handler for cubit [state] changes.
  /// When a change occurs, we treat the incoming information as current,
  /// and discard any local changes by overwriting the local state, thus triggering UI rebuild.
  void _onNewCubitState(BuildContext context, PredictionsState state) {
    setState(() {
      if (!(_isLoading = state is! PredictionsLoadSuccess)) {
        PredictionsLoadSuccess stateSuccess = state;
        _predictionsMap = Map.of(stateSuccess.predictions).map((key, value) => MapEntry(key, List.of(value)));
        // Remove every disabled player from the map
        _predictionsMap.values.forEach((List<Player> sectionPlayers) =>
            sectionPlayers.removeWhere((Player player) => !stateSuccess.enables[player]));
      }
    });
  }

  /// Builds a scrollable list widget which represents the predictions list.
  Widget _buildList(BuildContext context) {
    // Inserts all predictions into one list, with section keys separating them.
    List<dynamic> predictionsAndSections =
        _predictionsMap.entries.expand((element) => [element.key, ...element.value]).toList();

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: predictionsAndSections.length,
      itemBuilder: (BuildContext context, int index) =>
          _buildListEntry(context, predictionsAndSections[index]),
    );
  }

  /// Build an widget corresponding to the given [entry], to be shown in the predictions list.
  /// This is always either an un-draggable header, or a draggable player card.
  Widget _buildListEntry(BuildContext context, dynamic entry) {
    if (entry is PredictionsSection) {
      return ROL.ReorderableItem(
        key: ValueKey(entry),
        childBuilder: (BuildContext context, ROL.ReorderableItemState state) =>
            _Header(section: entry),
      );
    }

    if (entry is Player) {
      return ROL.ReorderableItem(
        key: ValueKey(entry),
        childBuilder: (BuildContext context, ROL.ReorderableItemState state) {
          if (state == ROL.ReorderableItemState.placeholder) {
            return SizedBox(height: 56 + _LIST_SPACING);
          }
          bool isRaised = (state == ROL.ReorderableItemState.dragProxy);
          return Padding(
            padding: EdgeInsets.symmetric(vertical: _LIST_SPACING / 2),
            child: _Entry(player: entry, isRaised: isRaised),
          );
        },
      );
    }

    _logger.severe("The entry is of unrecognized type.");
    throw "Invalid type.";
  }
}

class _EntryPosition {
  final PredictionsSection section;
  final int index;

  _EntryPosition({this.section, this.index});
}

class _Entry extends StatelessWidget {
  final Player _player;
  final bool _isRaised;

  const _Entry({Key key, Player player, bool isRaised})
      : _player = player,
        _isRaised = isRaised,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Color bgColor = _player.getColor();
    String playerName = _player.getNameLowercase();
    bool isBright = bgColor.computeLuminance() > 0.5;
    Color textColor = isBright ? Colors.black87 : Colors.white;

    Widget content = Material(
        borderRadius: BorderRadius.circular(4),
        elevation: _isRaised ? 8 : 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ListTile(
          mouseCursor: SystemMouseCursors.grab,
          visualDensity: VisualDensity.standard,
          leading: SizedBox(
            height: 40,
            child: Image(
                image: AssetImage("assets/players/$playerName.png"),
                isAntiAlias: true,
                filterQuality: FilterQuality.high),
          ),
          // Compensate for the icon added in the stack later on
          trailing: SizedBox(
            width: 24,
          ),
          title: BlocBuilder<PredictionsCubit, PredictionsState>(
            builder: (BuildContext context, PredictionsState state) =>
                _buildLabel(context, state, textColor),
          ),
          tileColor: bgColor,
        ));

    // TODO: Move this out into a service
    bool isMobile = (Platform.isIOS || Platform.isAndroid) &&
        !Platform.isMacOS &&
        !Platform.isWindows &&
        !Platform.isLinux;

    if (isMobile) {
      // Add a drag handle at the end of the tile. It"s here to allow for a bigger tap target.
      content = Stack(
        clipBehavior: Clip.none,
        children: [
          content,
          Positioned(
            right: 16,
            top: 16,
            child: Icon(
              Icons.drag_handle,
              color: textColor,
              size: 24,
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: ROL.ReorderableListener(
              child: Container(width: 56, height: 56, color: Colors.transparent),
            ),
          ),
        ],
      );
    } else {
      content = ROL.ReorderableListener(
        child: content,
      );
    }

    return content;
  }

  /// Builds an appropriate label based on the given [state].
  /// Sets the color to the given [textColor].
  Widget _buildLabel(BuildContext context, PredictionsState state, Color textColor) {
    String label;

    // If the predictions have been loaded, then look up the player's name.
    if (state is PredictionsLoadSuccess) {
      PredictionsLoadSuccess stateSuccess = state;
      label = stateSuccess.names[_player];
    } else {
      label = "Loading...";
    }

    // If the player name is empty then substitute it with the enumerated name.
    if (label.isEmpty) {
      label = _player.getCamelName();
    }

    // Return a text widget to represent the label.
    return Text(
      label,
      style: TextStyle(color: textColor),
    );
  }
}

class _Header extends StatelessWidget {
  final PredictionsSection _section;

  const _Header({Key key, PredictionsSection section})
      : _section = section,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle headline5 = Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(_section.getCamelName(), style: headline5),
    );
  }
}
