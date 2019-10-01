import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriptions/data/di/subscription_inject.dart';
import 'package:subscriptions/data/entities/renewal_period.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/data/repositories/subscription_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/WidgetsFormHelper/color_field_widget.dart';
import 'package:subscriptions/presentations/WidgetsFormHelper/date_field_widget.dart';
import 'package:subscriptions/presentations/WidgetsFormHelper/dismiss_keyboard_on_scroll.dart';
import 'package:subscriptions/presentations/WidgetsFormHelper/text_field_widget.dart';

class CreateSubscriptionScreen extends StatefulWidget {
  @override
  _CreateSubscriptionScreenState createState() =>
      _CreateSubscriptionScreenState();
}

class _CreateSubscriptionScreenState extends State<CreateSubscriptionScreen> {
  var _subscription = new Subscription();
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> mScaffoldState =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mScaffoldState,
      appBar: AppBar(
        title: Text("Create Subscription"),
        backgroundColor: _subscription.color,
      ),
      body: _buildForm(context),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: _buildInput(),
        ),
      ),
    );
  }

  FocusNode _name = FocusNode();
  FocusNode _description = FocusNode();
  FocusNode _price = FocusNode();
  FocusNode _firstBill = FocusNode();
  FocusNode _renewalCycle = FocusNode();
  FocusNode _subscriptionColor = FocusNode();
  String _dropdownValue = 'Day';

  Widget _buildInput() {
    return DismissKeyboardOnScroll(
      child: ListView(
        children: <Widget>[
          TextFieldWidget(
              onSave: (val) => _subscription.name = val,
              hint: "Name",
              focusNode: _name,
              nextFocusNode: _description,
              inputAction: TextInputAction.next),
          TextFieldWidget(
              onSave: (val) => _subscription.description = val,
              hint: "Description",
              focusNode: _description,
              nextFocusNode: _price,
              inputAction: TextInputAction.next),
          TextFieldWidget(
              onSave: (val) => _subscription.price = double.parse(val),
              iconPath: 'images/ic_price.png',
              hint: "Price",
              focusNode: _price,
              nextFocusNode: null,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputAction: TextInputAction.next),
          DateFieldWidget(
              onSave: (val) =>
                  _subscription.firstBill = DatesHelper.toDateFromString(val),
              iconPath: 'images/ic_price.png',
              hint: "First bill",
              focusNode: _firstBill,
              nextFocusNode: _renewalCycle,
              inputAction: TextInputAction.done),
          Row(
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFieldWidget(
                  onSave: (val) => _subscription.renewal = int.parse(val),
                  iconPath: 'images/ic_price.png',
                  hint: "Renewal Cycle",
                  focusNode: _renewalCycle,
                  keyboardType: TextInputType.numberWithOptions(decimal: false),
                  nextFocusNode: _subscriptionColor,
                  inputAction: TextInputAction.next,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: _buildDropDown(),
              ),
            ],
          ),
          ColorFieldWidget(
            colorSelected: (Color color) {
              setState(() {
                _subscription.color = color;
              });
            },
            iconPath: 'images/ic_price.png',
          ),
          _buildButtonSend(context),
        ],
      ),
    );
  }

  Widget _buildDropDown() {
    return DropdownButton<String>(
      hint: Text('Day'),
      isExpanded: true,
      underline: Container(
        height: 1,
        color: Colors.transparent,
      ),
      value: _dropdownValue,
      onChanged: (String newValue) {
        setState(() {
          _dropdownValue = newValue;
        });
      },
      items: RenewalPeriod.renewalCyclesValues(),
    );
  }

  _setRenewalPeriod() {
    _subscription.renewalPeriod = RenewalPeriod.enumOfString(_dropdownValue);
  }

  Widget _buildButtonSend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _setRenewalPeriod();
            saveSubscription();
          }
        },
        child: Text('Submit'),
      ),
    );
  }

  void saveSubscription() async {
    final result =
        await SubscriptionRepository(SubscriptionInject.buildSubscriptionDao())
            .saveSubscription(_subscription);
    if (result) {
      showSnackBar(message: "Subscripción guardada");
      //todo cerrar esto
    } else {
      showSnackBar(
          message: "Error guardadndo la subscripción, inténtelo de nuevo");
    }
  }

  void showSnackBar({String message}) {
    final snackBar = new SnackBar(content: new Text(message));
    mScaffoldState.currentState.showSnackBar(snackBar);
  }
}
