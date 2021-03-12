import "package:among_us_helper/modules/map/map_page.dart";
import "package:among_us_helper/modules/pathing/pathing_page.dart";
import "package:among_us_helper/modules/predictions/predictions_page.dart";
import "package:flutter/material.dart";

class AppViewExpanded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: MapPage(),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 350),
          child: PathingPage(),
        ),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 350),
          child: PredictionsPage(),
        ),
      ],
    );
  }
}
