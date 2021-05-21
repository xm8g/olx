import 'package:flutter/material.dart';

class ButtonCustomizado extends StatelessWidget {
  final String label;
  final Color colorLabel;
  final VoidCallback onPressed;

  const ButtonCustomizado({this.label, this.colorLabel = Colors.white, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text(label, style: TextStyle(color: colorLabel, fontSize: 20)),
        color: Color(0xFF9C27B0),
        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onPressed: onPressed);
  }
}
