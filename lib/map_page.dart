import 'package:among_us_helper/map.dart';
import "package:flutter/material.dart";
import "package:photo_view/photo_view.dart";

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> with TickerProviderStateMixin {
  static const double APP_BAR_HEIGHT = 56.0;

  AnimationController _animController;
  Animation<double> _curveAnim;
  Animation<double> _iconAnim;
  Animation<double> _menuItemsAnim;
  Animation<double> _menuItemsAnimReverse;
  bool _expanded = false;

  List<AUMap> _mapOptions = AUMap.values.toList(growable: false);
  int _selectedMap = 0;

  @override
  void initState() {
    _animController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200), value: 1)
          ..addListener(() {
            setState(() {});
          });
    _curveAnim = CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _iconAnim = _curveAnim;
    const mapEntriesHeight = APP_BAR_HEIGHT * 2;
    _menuItemsAnim = Tween<double>(begin: 0, end: mapEntriesHeight).animate(_curveAnim);
    _menuItemsAnimReverse = Tween<double>(begin: mapEntriesHeight, end: 0).animate(_curveAnim);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var safePadding = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        PhotoView(
          imageProvider: AssetImage("assets/maps/${_getSelectedMapLink()}.jpg"),
          backgroundDecoration: BoxDecoration(color: const Color(0xFF2E3444)),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black87, Colors.transparent]),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: _menuItemsAnimReverse.value,
                  ),
                  _buildAppBar(),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -(_menuItemsAnim.value + (_curveAnim.value * safePadding)),
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              children: _getNonSelectedMaps().map((map) =>
                _buildMapOption(
                    name: map.getName(),
                    onSelect: () => _selectMap(map)
                )).toList(growable: false)
            ),
          ),
        )
      ],
    );
  }

  Widget _buildMapOption({String name, Function onSelect}) {
    var textTheme =
        Theme.of(context).textTheme.headline6.copyWith(color: Colors.white, height: 1.2);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(name, style: textTheme)],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
        title: Text(_getSelectedMap().getName()),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  void _selectMap(AUMap map) {
    _selectedMap = _mapOptions.indexOf(map);
    if(_expanded) {
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

  AUMap _getSelectedMap() {
    return _mapOptions[_selectedMap];
  }

  String _getSelectedMapLink() {
    return _getSelectedMap().toString().split('.')[1].toLowerCase();
  }

  List<AUMap> _getNonSelectedMaps() {
    AUMap selectedMap = _getSelectedMap();
    return _mapOptions.where((element) => element != selectedMap).toList(growable: false);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }
}
