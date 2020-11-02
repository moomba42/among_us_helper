import 'dart:io';

import 'package:among_us_helper/player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_reorderable_list/flutter_reorderable_list.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

enum NotesSection {
  SUS,
  INNOCENT,
  UNKNOWN,
  DEAD
}

class _NotesPageState extends State<NotesPage> {

  List<dynamic> _notesList = [
    NotesSection.SUS,
    NotesSection.INNOCENT,
    NotesSection.UNKNOWN, ...Player.values,
    NotesSection.DEAD
  ];

  int _indexOfKey(ValueKey key) {
    return _notesList.indexWhere((dynamic p) => key.value == p);
  }

  bool _reorderCallback(Key item, Key newPosition) {
    // Prevent reordering section headers
    if(item is ValueKey && item.value is NotesSection) {
      return false;
    }

    int draggingIndex = _indexOfKey(item);
    int newPositionIndex = _indexOfKey(newPosition);

    if(newPositionIndex == 0) {
      return false;
    }

    final draggedItem = _notesList[draggingIndex];
    setState(() {
      _notesList.removeAt(draggingIndex);
      _notesList.insert(newPositionIndex, draggedItem);
    });

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var headline3 = Theme.of(context).textTheme.headline3.copyWith(color: Colors.black87);

    return SafeArea(
      child: ReorderableList(
        decoratePlaceholder: (widget, opacity) { return DecoratedPlaceholder(offset: 0, widget: widget);},
        onReorderDone: (item) {},
        onReorder: _reorderCallback,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Notes', style: headline3),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              sliver: SliverList(
                delegate:  SliverChildBuilderDelegate(
                  _buildListEntry,
                  childCount: _notesList.length
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  Widget _buildListEntry(BuildContext context, int index) {

    dynamic entry = _notesList[index];

    if(entry is NotesSection) {
      return _buildHeader(context, entry);
    }

    if(entry is Player) {
      return _buildEntry(context, entry);
    }

    throw "Invalid index";
  }

  Widget _buildHeader(BuildContext context, NotesSection section) {
    var headline5 = Theme.of(context).textTheme.headline5.copyWith(color: Colors.black87);
    var label = section.toString().split('.')[1];
    label = label.substring(0, 1).toUpperCase() + label.substring(1).toLowerCase();

    return ReorderableItem(
      key: ValueKey(section),
      childBuilder: (context, state) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(label, style: headline5),
      ),
    );
  }

  Widget _buildEntry(BuildContext context, Player player) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: ReorderableItem(
        key: ValueKey(player),
        childBuilder: (context, state) => _buildEntryContent(context, state, player),
      ),
    );
  }

  Widget _buildEntryContent(BuildContext context, ReorderableItemState state, Player player) {

    if(state == ReorderableItemState.placeholder) {
      return SizedBox(height: 56);
    }

    Color bgColor = player.getColor();
    bool isBright = bgColor.computeLuminance() > 0.5;
    String name = player.toString().split('.')[1].toLowerCase();
    String camelName = name.substring(0, 1).toUpperCase() + name.substring(1);
    Color textColor = isBright ? Colors.black87 : Colors.white;

    Widget trailing = Icon(Icons.drag_handle, color: textColor);

    var isMobile = (Platform.isIOS || Platform.isAndroid) &&
        !Platform.isMacOS && !Platform.isWindows && !Platform.isLinux;

    if(isMobile) {
      trailing = ReorderableListener(child: trailing);
    }

    Widget content = Material(
        borderRadius: BorderRadius.circular(4),
        elevation: state == ReorderableItemState.dragProxy ? 8 : 2,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ListTile(
          mouseCursor: SystemMouseCursors.grab,
          visualDensity: VisualDensity.standard,
          leading: SizedBox(
              height: 40,
              child: Image(
                  image: AssetImage("assets/players/$name.png"),
                  isAntiAlias: true,
                  filterQuality: FilterQuality.high
              )
          ),
          trailing: trailing,
          title: Text(camelName, style: TextStyle(color: textColor)),
          tileColor: bgColor,
        )
    );

    if(!isMobile) {
      content = ReorderableListener(
        child: content,
      );
    }
    
    return content;
  }
}
