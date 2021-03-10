import "package:among_us_helper/core/widgets/title_bar.dart";
import "package:among_us_helper/modules/player_config/player_config_page.dart";
import "package:among_us_helper/modules/predictions/predictions_list.dart";
import "package:flutter/material.dart";

class PredictionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleBar(
          title: "Predictions",
          actions: [
            IconButton(
              iconSize: 32,
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => PlayerConfigPage()),
              ),
            ),
          ],
        ),
        Expanded(child: PredictionsList()),
      ],
    );
  }
}
