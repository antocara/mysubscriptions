import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/presentations/styles/colors.dart';
import 'package:subscriptions/presentations/styles/text_styles.dart';

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
    this.icons,
  }) : super(key: key);

  final String hint;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputAction inputAction;
  final TextInputType keyboardType;
  final Function onSave;
  final Function onChange;
  final IconData icons;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.1),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0),
        child: TextFormField(
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: widget.hint,
            hintText: "",
            labelStyle: kInputFormHint,
            hintStyle: kInputFormHint,
            icon: Icon(
              widget.icons,
              color: kPrimaryColor,
              size: 20,
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return AppLocalizations.of(context).translate("error_mandatory_field");
            }
            return null;
          },
          style: kInputFormContent,
          keyboardType: widget.keyboardType,
          focusNode: widget.focusNode,
          textInputAction: widget.inputAction,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, widget.focusNode, widget.nextFocusNode);
          },
          onChanged: widget.onChange,
          onSaved: widget.onSave,
        ),
      ),
    );
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
