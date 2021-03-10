import 'dart:math';

import 'package:among_us_helper/core/model/pathing_entry.dart';
import 'package:among_us_helper/core/model/player.dart';
import "package:among_us_helper/modules/map/cubit/map_cubit.dart";
import "package:among_us_helper/modules/map/map_display.dart";
import "package:among_us_helper/core/model/au_map.dart";
import "package:among_us_helper/modules/map/player_select.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:photo_view/photo_view.dart";

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const double MAP_WIDTH = 4000;
  static const double MAP_HEIGHT = 2600;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => PhotoView.customChild(
          child: BlocBuilder<MapCubit, MapState>(
            builder: _buildMapForState,
          ),
          childSize: Size(MAP_WIDTH, MAP_HEIGHT),
          backgroundDecoration: BoxDecoration(color: const Color(0xFF2E3444)),
          onTapUp: (context, details, value) => _onPhotoViewClicked(details, value, constraints)),
    );
  }

  Widget _buildMapForState(BuildContext context, MapState state) {
    if (state is! MapLoadSuccess) {
      return Center(
        child: SizedBox(
          width: 128,
          height: 128,
          child: CircularProgressIndicator(
            strokeWidth: 12,
          ),
        ),
      );
    }

    MapLoadSuccess stateSuccess = state;

    var assetImage = SvgPicture.asset(stateSuccess.map.getSvgAsset());

    return MapDisplay(
      mapImage: assetImage,
      pathing: stateSuccess.pathing,
    );
  }

  void _onPhotoViewClicked(
      TapUpDetails details, PhotoViewControllerValue value, BoxConstraints widget) {
    // [value.position] is the position of the middle of the screen relative
    // to the center of the image, in screen pixels.
    // [details.localPosition] is the position of the cursor
    // relative to the widget, in pixels

    // Get the position of the middle of the screen relative to the center of the image in image pixels.
    Offset widgetCenterOnImageOnImage = value.position / value.scale;

    // Get the widget size in screen pixels.
    Offset widgetSizeOnScreen = Offset(widget.maxWidth, widget.maxHeight);

    // Get the click position in screen pixels, relative to the top left corner of the widget.
    Offset clickTopLeftOnScreen = details.localPosition;

    // Get the click position relative to the widget center in screen pixels.
    // X axis pints to the left, Y axis points up.
    Offset clickRelativeToCenterOnScreen = (widgetSizeOnScreen / 2) - clickTopLeftOnScreen;

    Offset clickRelativeToWidgetCenterOnImage = clickRelativeToCenterOnScreen / value.scale;

    // Get the click position in image pixels, relative to the image center.
    Offset clickPos = widgetCenterOnImageOnImage + clickRelativeToWidgetCenterOnImage;

    Offset imageSize = Offset(MAP_WIDTH, MAP_HEIGHT);

    // Get the click position in image pixels, relative to the image"s top left corner.
    Offset clickOnImage = (imageSize / 2) - clickPos;

    _onMapClicked(clickOnImage);
  }

  void _onMapClicked(Offset inPixels) {
    showModalBottomSheet<Set<Player>>(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      builder: (context) => PlayerSelect(),
    ).then((Set<Player> selectedPlayers) {
      if (selectedPlayers == null || selectedPlayers.isEmpty) {
        return;
      }

      this.context.read<MapCubit>().createPathingEntryAt(
            position: inPixels,
            players: selectedPlayers,
          );
    });
  }
}
