import "package:among_us_helper/core/widgets/title_bar.dart";
import "package:among_us_helper/modules/player_names/player_names_page.dart";
import "package:among_us_helper/modules/predictions/cubit/predictions_cubit.dart";
import "package:among_us_helper/modules/predictions/predictions_list.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PredictionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleBar(
          title: "Predictions",
          actions: [
            IconButton(
              icon: Icon(Icons.autorenew),
              onPressed: () => context.read<PredictionsCubit>().reset(),
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) => PlayerNamesPage())),
            ),
          ],
        ),
        Expanded(child: PredictionsList()),
      ],
    );
  }
}
