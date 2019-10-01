import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriptions/presentations/WidgetsFormHelper/icon_field_widget.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {Key key,
      this.iconPath,
      this.hint,
      this.focusNode,
      this.nextFocusNode,
      this.inputAction,
      this.keyboardType,
      this.onSave})
      : super(key: key);

  final String iconPath;
  final String hint;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputAction inputAction;
  final TextInputType keyboardType;
  final Function onSave;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: widget.hint,
          icon: IconFormField(iconPath: widget.iconPath),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some value';
          }
          return null;
        },
        keyboardType: widget.keyboardType,
        focusNode: widget.focusNode,
        textInputAction: widget.inputAction,
        onFieldSubmitted: (term) {
          _fieldFocusChange(context, widget.focusNode, widget.nextFocusNode);
        },
        onSaved: widget.onSave,
      ),
    );
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
