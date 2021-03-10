import "package:flutter/material.dart";

class ConfirmationDialog extends StatelessWidget {
  final Widget title;
  final Widget content;

  const ConfirmationDialog({Key key, this.title, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Padding(
        child: Text("CANCEL"),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
      ),
      onPressed: () {
        Navigator.pop(context, Confirmation.DENIED);
      },
    );

    Widget okButton = ElevatedButton(
      child: Padding(
        child: Text("OK"),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 32),
      ),
      onPressed: () {
        Navigator.pop(context, Confirmation.ACCEPTED);
      },
    );

    return AlertDialog(
      title: title,
      actionsPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      content: content,
      actions: [
        cancelButton,
        okButton,
      ],
    );
  }

  static Future<Confirmation> showConfirmationDialog(
      {BuildContext context, Widget title, Widget content}) {
    return showDialog<Confirmation>(
      context: context,
      builder: (BuildContext context) => ConfirmationDialog(
        title: title,
        content: content,
      ),
    );
  }
}

enum Confirmation { ACCEPTED, DENIED }
