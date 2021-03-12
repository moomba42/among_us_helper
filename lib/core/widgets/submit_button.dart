import "package:flutter/material.dart";

class SubmitButton extends StatelessWidget {
  /// Callback for when the button is pressed.
  final Function onPressed;

  /// Text shown in the center of the button.
  final String label;

  /// Used to construct a leading icon.
  final IconData leadingIcon;

  /// If `false` the button will be un-clickable.
  final bool enabled;

  const SubmitButton({Key key, this.onPressed, this.label, this.leadingIcon, this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: _buildStyle(context),
      onPressed: enabled ? onPressed : null,
      child: _buildContent(context),
    );
  }

  /// Styles the button to make it bigger and change colors when disabled.
  ButtonStyle _buildStyle(BuildContext context) {
    return ButtonStyle(
      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 18)),
      backgroundColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Theme.of(context).buttonTheme.colorScheme.onSurface.withOpacity(0.38);
        }

        return Theme.of(context).buttonTheme.colorScheme.primary;
      }),
    );
  }

  /// Builds the content of the button.
  Widget _buildContent(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 30,
          child: Icon(
            leadingIcon,
            color: Theme.of(context).primaryIconTheme.color,
          ),
        ),
        Center(
          child: Text(
            label,
            style: Theme.of(context).primaryTextTheme.headline6,
          ),
        )
      ],
    );
  }
}
