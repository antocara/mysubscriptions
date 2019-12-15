import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/styles/colors.dart';
import 'package:subscriptions/presentations/styles/text_styles.dart';

class DateFieldWidget extends StatefulWidget {
  const DateFieldWidget({
    Key key,
    this.hint,
    this.focusNode,
    this.nextFocusNode,
    this.inputAction,
    this.inputType,
    this.onSave,
    this.onChange,
    this.icons,
  }) : super(key: key);

  final String hint;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputAction inputAction;
  final List<TextInputFormatter> inputType;
  final Function onSave;
  final Function onChange;
  final IconData icons;

  @override
  _DateFieldWidgetState createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.1),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: _selectDate,
        child: IgnorePointer(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 0),
            child: TextFormField(
              controller: _controller,
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: widget.hint,
                labelStyle: kInputFormHint,
                hintStyle: kInputFormHint,
                icon: Icon(widget.icons, color: kPrimaryColor),
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: kInputFormContent,
              inputFormatters: widget.inputType,
              focusNode: widget.focusNode,
              textInputAction: widget.inputAction,
              onFieldSubmitted: (term) {
                _fieldFocusChange(
                    context, widget.focusNode, widget.nextFocusNode);
              },
              onSaved: widget.onSave,
              onChanged: widget.onChange,
            ),
          ),
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
