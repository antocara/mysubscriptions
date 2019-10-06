import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class DateFieldWidget extends StatefulWidget {
  const DateFieldWidget(
      {Key key,
      this.hint,
      this.focusNode,
      this.nextFocusNode,
      this.inputAction,
      this.inputType,
      this.onSave,
      this.onChange})
      : super(key: key);

  final String hint;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputAction inputAction;
  final List<TextInputFormatter> inputType;
  final Function onSave;
  final Function onChange;

  @override
  _DateFieldWidgetState createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _selectDate,
      child: IgnorePointer(
        child: TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: widget.hint,
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          inputFormatters: widget.inputType,
          focusNode: widget.focusNode,
          textInputAction: widget.inputAction,
          onFieldSubmitted: (term) {
            _fieldFocusChange(context, widget.focusNode, widget.nextFocusNode);
          },
          onSaved: widget.onSave,
          onChanged: widget.onChange,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // other dispose methods
    _controller.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(3020));
    if (picked != null)
      setState(() {
        final textValue = DatesHelper.toStringFromDate(picked);
        _controller.value = TextEditingValue(text: textValue);
        widget.onChange(textValue);
      });
  }
}
