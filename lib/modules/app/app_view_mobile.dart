import "package:among_us_helper/core/icons.dart";
import "package:among_us_helper/core/widgets/confirmation_dialog.dart";
import 'package:among_us_helper/modules/app/cubit/map_cubit.dart';
import "package:among_us_helper/modules/app/cubit/pathing_cubit.dart";
import 'package:among_us_helper/modules/app/cubit/player_config_cubit.dart';
import "package:among_us_helper/modules/app/cubit/predictions_cubit.dart";
import "package:among_us_helper/modules/map/map_page.dart";
import "package:among_us_helper/modules/pathing/pathing_page.dart";
import "package:among_us_helper/modules/predictions/predictions_page.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:among_us_helper/core/model/au_map.dart";

/// Widget that displays the most important app screens in a mobile format, using a tabbed view.
class AppViewMobile extends StatefulWidget {
  @override
  _AppViewMobileState createState() => _AppViewMobileState();
}

class _AppViewMobileState extends State<AppViewMobile> {
  /// Local UI state holding the selected tab.
  _Tab _selectedTab = _Tab.MAP;

  @override
  Widget build(BuildContext context) {
    Color canvasColor = Theme.of(context).canvasColor;

    return Scaffold(
      bottomNavigationBar: _buildNavigationBar(context),
      backgroundColor: canvasColor,
      body: _buildTabContent(),
      floatingActionButton: _buildActionButton(),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case _Tab.PREDICTIONS:
        return PredictionsPage();
      case _Tab.PATHING:
        return PathingPage();
      case _Tab.MAP:
      default:
        return MapPage();
    }
  }

  Widget _buildActionButton() {
    return FloatingActionButton.extended(
      onPressed: _startNewRound,
      label: Text("NEW ROUND"),
      icon: Icon(Icons.refresh),
    );
  }

  Widget _buildNavigationBar(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    List<BottomNavigationBarItem> itemsFromEnum = _Tab.values.map(_buildNavigationItem).toList();

    return BottomNavigationBar(
      items: itemsFromEnum,
      currentIndex: this._selectedTab.index,
      onTap: _onTabTapped,
      backgroundColor: primaryColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white54,
    );
  }

  /// Builds a navigation item based on a given [tab].
  BottomNavigationBarItem _buildNavigationItem(_Tab tab) {
    switch (tab) {
      case _Tab.PREDICTIONS:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.edit),
          label: "Predictions",
        );
      case _Tab.PATHING:
        return const BottomNavigationBarItem(
          icon: Icon(CustomIcons.vector),
          label: "Pathing",
        );
      case _Tab.MAP:
      default:
        return const BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: "Map",
        );
    }
  }

  /// Handles the event of tapping a tab with the specified [tabIndex].
  /// Switches to that tab.
  void _onTabTapped(int tabIndex) {
    setState(() {
      this._selectedTab = _Tab.values[tabIndex];
    });
  }

  /// Resets pathing and predictions to let the player start a new round.
  void _startNewRound() {
    ConfirmationDialog.showConfirmationDialog(
      context: context,
      title: Text("Starting new round"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("This will reset the pathing information & predictions."),
          Text("Player names will be preserved."),
          SizedBox(height: 8),
          Text("Are you sure you want to continue?"),
        ],
      ),
    ).then((Confirmation confirmation) {
      if (confirmation != Confirmation.ACCEPTED) {
        return;
      }

      context.read<MapCubit>().changeSelection(AUMap.MIRA);
      context.read<PathingCubit>().reset();
      context.read<PredictionsCubit>().reset();
      context.read<PlayerConfigCubit>().reset();
    });
  }
}

enum _Tab { MAP, PATHING, PREDICTIONS }
