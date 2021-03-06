import "package:among_us_helper/modules/predictions/cubit/predictions_cubit.dart";
import "package:among_us_helper/modules/predictions/predictions_list.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class PredictionsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Headline(
          onReset: () => context.read<PredictionsCubit>().reset(),
        ),
        Expanded(child: PredictionsList()),
      ],
    );
  }
}

class _Headline extends StatelessWidget {
  final void Function() _onReset;
  final void Function() _onSettings;

  _Headline({void Function() onReset, void Function() onSettings})
      : _onReset = onReset,
        _onSettings = onSettings;

  @override
  Widget build(BuildContext context) {
    var headline3 = Theme.of(context).textTheme.headline3.copyWith(color: Colors.black87);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        textBaseline: TextBaseline.ideographic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Notes", style: headline3),
          // FlatButton(onPressed: () {}, child: Text("New Round"))
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.autorenew),
                onPressed: _onReset,
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: _onSettings,
              )
            ],
          )
        ],
      ),
    );
  }
}
