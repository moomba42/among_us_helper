import 'package:among_us_helper/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PlayerSelect extends StatefulWidget {

  final Function(List<Player>) onSelected;

  const PlayerSelect({Key key, this.onSelected}) : super(key: key);

  @override
  _PlayerSelectState createState() => _PlayerSelectState();
}

class _PlayerSelectState extends State<PlayerSelect> {

  Map<Player, bool> _selection = Map.fromEntries(Player.values.map((e) => MapEntry(e, false)).toList(growable: false));

  void _onPlayerToggle(Player player) {
    setState(() {
      _selection.update(player, (value) => !value);
    });
  }

  void _onSubmit() {
    widget.onSelected(_getSelectedPlayers());
  }

  List<Player> _getSelectedPlayers() {
    return _selection.entries
        .where((element) => element.value)
        .map((e) => e.key)
        .toList(growable: false);
  }

  bool _isAnythingSelected() {
    return _getSelectedPlayers().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    var headlineStyle = Theme.of(context).textTheme.headline5;
    const contentSpacing = 16.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(contentSpacing, 8, contentSpacing, contentSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDragHandle(),
          SizedBox(height: contentSpacing),
          Text(
              "Who was here?",
              style: headlineStyle
          ),
          SizedBox(height: contentSpacing),
          GridView.count(
            primary: true,
            shrinkWrap: true,
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 8),
            children: _selection.entries
                .map((entry) => _buildPlayerOption(entry.key, entry.value))
                .toList(growable: false),
          ),
          _buildSubmitButton(
            onPressed: _isAnythingSelected() ? _onSubmit : null,
            label: "Confirm Positions",
            icon: Icons.check_circle
          )
        ],
      ),
    );
  }

  Widget _buildPlayerOption(Player player, bool selected) {
    var primaryColor = Theme.of(context).primaryColor;

    Color bgColor = player.getColor();
    bool isBright = bgColor.computeLuminance() > 0.5;
    String name = player.toString().split('.')[1].toLowerCase();
    String camelName = name.substring(0, 1).toUpperCase() + name.substring(1);
    Color textColor = isBright ? Colors.black87 : Colors.white;

    var button = RaisedButton(
      elevation: selected ? 4 : null,
      onPressed: () => _onPlayerToggle(player),
      color: player.getColor(),
      padding: EdgeInsets.zero,
      animationDuration: Duration(milliseconds: 200),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
      ),
      child: Stack(children: [
        Positioned(
          left: -30,
          bottom: -60,
          right: 20,
          top: 40,
          child: Image(
              image: AssetImage("assets/players/$name.png"),
              isAntiAlias: true,
              filterQuality: FilterQuality.high
          )
        ),
        Container(constraints: BoxConstraints.expand(),),
        Positioned(
          left: 16,
            top: 8,
            child: Text(
              camelName,
              style: Theme.of(context).textTheme.bodyText2.copyWith(color: textColor)
            )
        )
      ]),
    );

    var decoration = ShapeDecoration(
        color: selected ? primaryColor.withOpacity(0.54) : primaryColor.withOpacity(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
    );

    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 200),
      padding: EdgeInsets.all(selected ? 6 : 0),
      decoration: decoration,
      child: button,
    );
  }

  Widget _buildDragHandle() {
    return Align(
      alignment: Alignment.center,
      child: Container(
          height: 3,
          width: 100,
          decoration: ShapeDecoration(
              color: Colors.black38,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))
          )
      ),
    );
  }

  Widget _buildSubmitButton({Function onPressed, String label, IconData icon}) {
    return RaisedButton(
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(vertical: 18),
      color: Theme.of(context).primaryColor,
      child: Stack(
        children: [
          Positioned(
              left: 30,
              child: Icon(icon, color: Theme.of(context).primaryIconTheme.color)
          ),
          Center(
            child: Text(label, style: Theme.of(context).primaryTextTheme.headline6)
          )
        ],
      ),
    );
  }
}
