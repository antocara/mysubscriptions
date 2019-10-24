import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriptions/presentations/components/WidgetsFormHelper/icon_field_widget.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    Key key,
    this.hint,
    this.focusNode,
    this.nextFocusNode,
    this.inputAction,
    this.keyboardType,
    this.onSave,
    this.onChange,
  }) : super(key: key);

  final String hint;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputAction inputAction;
  final TextInputType keyboardType;
  final Function onSave;
  final Function onChange;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: widget.hint,
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
        onChanged: widget.onChange,
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
