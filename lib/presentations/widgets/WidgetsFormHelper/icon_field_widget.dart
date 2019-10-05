import 'package:flutter/material.dart';

class IconFormField extends StatefulWidget {
  IconFormField({Key key, this.iconPath});

  final String iconPath;

  @override
  _IconFormFieldState createState() => _IconFormFieldState();
}

class _IconFormFieldState extends State<IconFormField> {
  @override
  Widget build(BuildContext context) {
    if (widget.iconPath != null && widget.iconPath.isNotEmpty) {
      return Image.asset(
        widget.iconPath,
        fit: BoxFit.fill,
        width: 25,
        height: 25,
      );
    } else {
      return SizedBox(
        width: 0,
        height: 0,
      );
    }
  }
}
