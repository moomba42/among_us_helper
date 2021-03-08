import "package:among_us_helper/core/model/au_map.dart";
import "package:among_us_helper/modules/map/cubit/map_cubit.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";

class MapSelectOverlay extends StatefulWidget {
  final Widget body;

  const MapSelectOverlay({Key key, this.body}) : super(key: key);

  @override
  _MapSelectOverlayState createState() => _MapSelectOverlayState();
}

class _MapSelectOverlayState extends State<MapSelectOverlay> with TickerProviderStateMixin {
  static const double APP_BAR_HEIGHT = 56.0;

  AnimationController _animController;
  Animation<double> _curveAnim;
  Animation<double> _iconAnim;
  bool _expanded = false;

  @override
  void initState() {
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200), value: 1)
          ..addListener(() {
            setState(() {});
          });
    _curveAnim = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _iconAnim = _curveAnim;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.body,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _buildAppBar(),
        )
      ],
    );
  }

  Widget _buildAppBar() {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            child: _GradientBackground(),
          ),
        ),
        BlocBuilder<MapCubit, MapState>(
          builder: (BuildContext context, MapState state) {
            AUMap map = AUMap.MIRA;

            if (state is MapLoadSuccess) {
              MapLoadSuccess stateSuccess = state;
              map = stateSuccess.map;
            }

            List<AUMap> others = List.of(AUMap.values)..remove(map);

            return Column(
              children: [
                _buildSelection(map),
                AnimatedContainer(
                  height: _expanded ? APP_BAR_HEIGHT * (AUMap.values.length - 1) : 0,
                  duration: Duration(milliseconds: 200),
                  child: _buildMapOptionsList(others),
                )
              ],
            );
          },
        )
      ],
    );
  }

  Widget _buildMapOption(AUMap map) {
    var textTheme =
        Theme.of(context).textTheme.headline6.copyWith(color: Colors.white, height: 1.2);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectMap(map),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(map.getName(), style: textTheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelection(AUMap map) {
    return SizedBox(
      height: APP_BAR_HEIGHT,
      child: AppBar(
        leading: IconButton(
          icon: AnimatedIcon(
            icon: AnimatedIcons.close_menu,
            progress: _iconAnim,
          ),
          onPressed: _toggleMapSelect,
        ),
        centerTitle: true,
        title: Text(map.getName()),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void _selectMap(AUMap map) {
    context.read<MapCubit>().setMap(map);
    if (_expanded) {
      _expanded = false;
      _animController.forward();
    }
  }

  void _toggleMapSelect() {
    if (_expanded) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
    _expanded = !_expanded;
  }

  Widget _buildMapOptionsList(List<AUMap> maps) {
    return Column(
        children: maps
            .map((map) => _buildMapOption(map))
            .map((optionWidget) => Expanded(child: optionWidget))
            .toList(growable: false));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}

class _GradientBackground extends StatelessWidget {
  const _GradientBackground({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black87, Colors.transparent]),
      ),
    );
  }
}
