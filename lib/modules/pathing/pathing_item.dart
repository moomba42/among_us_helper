import "dart:ui";

import "package:among_us_helper/core/ui_functions.dart";
import "package:flutter/material.dart";

class PathingTile extends StatelessWidget {
  final String label;
  final Widget icon;
  final Color tileColor;
  final Map<String, int> pathing;

  const PathingTile(
      {Key key, this.label, this.icon, this.tileColor, this.pathing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isBright = tileColor.computeLuminance() > 0.5;
    var textColor = isBright ? Colors.black87 : Colors.white;

    return Card(
      elevation: 2,
      shadowColor: Colors.black,
      clipBehavior: Clip.antiAlias,
      color: tileColor,
      child: setExpansionTileTextColor(
          color: textColor,
          expansionTile: ExpansionTile(
            visualDensity: VisualDensity.standard,
            tilePadding: EdgeInsets.symmetric(horizontal: 16),
            leading: SizedBox(height: 40, child: icon),
            title: Text(label, style: TextStyle(color: textColor)),
            childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              SizedBox(height: 16),
              _buildDetails(context, isBright),
              SizedBox(height: 16),
            ],
          )),
    );
  }

  Widget setExpansionTileTextColor({Color color, ExpansionTile expansionTile}) {
    var theme = ThemeData(accentColor: color, unselectedWidgetColor: color);
    return Theme(
      data: theme,
      child: expansionTile,
    );
  }

  Widget _buildDetails(BuildContext context, bool isBrightBackground) {
    var textColor = isBrightBackground ? Colors.black87 : Colors.white;
    var dividerColor = isBrightBackground ? Colors.black54 : Colors.white60;

    var labelTextTheme = Theme.of(context).textTheme.bodyText2.copyWith(color: textColor);
    var timeTextTheme = labelTextTheme.copyWith(fontFeatures: [FontFeature.tabularFigures()]);

    var entries = pathing.entries.map((entry) {
      var formattedTime = "${formatTime(entry.value)}";
      bool isLast = pathing.entries.last.value == entry.value;

      return Column(
        children: [
          Row(children: [
            Text(entry.key, style: labelTextTheme),
            Text(formattedTime, style: timeTextTheme)
          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
          if (!isLast) Divider(color: dividerColor)
        ],
      );
    }).toList();

    return Column(
      children: entries,
    );
  }

  String formatTime(int time) {
    Duration duration = Duration(milliseconds: time);

    return [duration.inMinutes, duration.inSeconds]
        .map((seg) => seg.remainder(60).toString().padLeft(2, "0"))
        .join(":");
  }
}
