import "package:among_us_helper/core/icons.dart";
import "package:among_us_helper/core/widgets/confirmation_dialog.dart";
import "package:among_us_helper/modules/app/cubit/pathing_cubit.dart";
import "package:among_us_helper/modules/app/cubit/predictions_cubit.dart";
import "package:among_us_helper/modules/map/map_page.dart";
import "package:among_us_helper/modules/pathing/pathing_page.dart";
import "package:among_us_helper/modules/predictions/predictions_page.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

/// Widget that displays the most important app screens in a mobile format, using a tabbed view.
class AppViewMobile extends StatefulWidget {
  @override
  _AppViewMobileState createState() => _AppViewMobileState();
}

class _AppViewMobileState extends State<AppViewMobile> {
  /// Local UI state keeping track of the selected tab.
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
    switch (_selectedTab) {
      case _Tab.MAP:
        return FloatingActionButton.extended(
          onPressed: _clearMap,
          label: Text("CLEAR"),
          icon: Icon(Icons.close),
        );
      case _Tab.PREDICTIONS:
        return FloatingActionButton.extended(
          onPressed: _resetPredictions,
          label: Text("RESET"),
          icon: Icon(Icons.refresh),
        );
      case _Tab.PATHING:
      default:
        return null;
    }
  }

  Widget _buildNavigationBar(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    // Build a tab for each [_Tab] value.
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

  /// Creates a confirmation dialog, and if confirmed, clears the pathing information.
  void _clearMap() {
    ConfirmationDialog.showConfirmationDialog(
      context: context,
      title: Text("Clearing map"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("This will reset the pathing information."),
          SizedBox(height: 8),
          Text("Are you sure you want to continue?"),
        ],
      ),
    ).then((Confirmation confirmation) {
      if (confirmation == Confirmation.ACCEPTED) {
        context.read<PathingCubit>().reset();
      }
    });
  }

  /// Resets the player predictions. All players are put into the unknown section.
  void _resetPredictions() {
    context.read<PredictionsCubit>().reset();
  }
}

enum _Tab { MAP, PATHING, PREDICTIONS }
