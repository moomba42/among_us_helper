import "package:among_us_helper/modules/app/app_page.dart";
import "package:flutter/material.dart";
import "package:logging/logging.dart";

void main() {
  initializeLogging();
  runApp(AmongUsHelperApp());
}

void initializeLogging() {
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print("${record.level.name}: ${record.time}: ${record.message}");
  });
}

class AmongUsHelperApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppPage();
  }
}
