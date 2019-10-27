import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/presentations/components/WidgetsFormHelper/icon_field_widget.dart';
import 'package:subscriptions/presentations/styles/colors.dart';
import 'package:subscriptions/presentations/styles/text_styles.dart';

typedef ColorSelected(Color color);

class ColorFieldWidget extends StatefulWidget {
  const ColorFieldWidget({Key key, this.colorSelected}) : super(key: key);

  final ColorSelected colorSelected;

  @override
  _ColorFieldWidgetState createState() => _ColorFieldWidgetState();
}

class _ColorFieldWidgetState extends State<ColorFieldWidget> {
  Color _currentColor;

  @override
  void initState() {
    _currentColor = kPrimaryColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Row(
        children: <Widget>[
          Text(
            AppLocalizations.of(context).translate("color"),
            style: kInputFormContent,
          ),
          SizedBox(
            width: 5,
          ),
          _buildCircleColor(),
        ],
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: <Widget>[
              RaisedButton(
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: new Text('Aceptar'),
              ),
            ],
            titlePadding: const EdgeInsets.all(10),
            contentPadding: const EdgeInsets.all(0.0),
            title: Text("Select Color "),
            content: SingleChildScrollView(
              child: MaterialPicker(
                pickerColor: _currentColor,
                onColorChanged: (Color color) {
                  widget.colorSelected(color);
                  setState(() => _currentColor = color);
                },
                enableLabel: true,
              ),
            ),
          );
        });
  }

  Widget _buildCircleColor() {
    return Expanded(
      child: InkWell(
        onTap: _showColorPicker,
        child: Container(
          height: 50,
          child: Card(
            color: _currentColor,
          ),
        ),
      ),
    );
  }
}
