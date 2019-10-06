import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:subscriptions/presentations/widgets/WidgetsFormHelper/icon_field_widget.dart';

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
    _currentColor = Colors.black;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0),
      child: Row(
        children: <Widget>[
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
    return InkWell(
      onTap: _showColorPicker,
      child: Container(
        width: 100,
        height: 50,
        child: Card(
          color: _currentColor,
        ),
      ),
    );
  }
}
