import "package:among_us_helper/core/widgets/system_container_padding.dart";
import "package:flutter/material.dart";

class TitleBar extends StatelessWidget {
  /// Used to determine the default padding of the title bar, and other elements, for consistency.
  static const double _PADDING = 16.0;

  /// The text of the title widget.
  final String title;

  /// List of widgets to be shown after the title widget,
  /// sticking to the right side of this widget.
  final List<Widget> actions;

  /// A widget that is shown before the title widget, at the beginning.
  /// Usually an icon button to navigate back.
  final Widget leading;

  const TitleBar({Key key, this.actions, this.title, this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle headline3 = Theme.of(context).textTheme.headline3;
    return SafeArea(
      child: SystemContainerPadding(
        child: Padding(
          padding: EdgeInsets.all(_PADDING),
          child: Row(
            textBaseline: TextBaseline.ideographic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            // Pushes actions apart to the right, from leading and title widgets.
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (leading != null) leading,
                  if (leading != null) SizedBox(width: _PADDING),
                  Text(title, style: headline3),
                ],
              ),
              if (actions != null) Row(children: actions),
            ],
          ),
        ),
      ),
    );
  }
}
