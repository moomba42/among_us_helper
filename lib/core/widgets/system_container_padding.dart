import "dart:io";

import "package:flutter/material.dart";

class SystemContainerPadding extends StatelessWidget {
  final Widget child;

  const SystemContainerPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Listen for windows fullscreen mode on macos, and disable padding when that happens.
    double titleBarPadding = Platform.isMacOS ? 21 : 0;

    return Padding(
      padding: EdgeInsets.only(top: titleBarPadding),
      child: child,
    );
  }
}
