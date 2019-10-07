import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriptions/data/di/subscription_inject.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/renewal_period.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/uncoming_renewals/card_row.dart';
import 'package:subscriptions/presentations/widgets/WidgetsFormHelper/color_field_widget.dart';
import 'package:subscriptions/presentations/widgets/WidgetsFormHelper/date_field_widget.dart';
import 'package:subscriptions/presentations/widgets/WidgetsFormHelper/dismiss_keyboard_on_scroll.dart';
import 'package:subscriptions/presentations/widgets/WidgetsFormHelper/text_field_widget.dart';

class CreateSubscriptionScreen extends StatefulWidget {
  @override
  _CreateSubscriptionScreenState createState() =>
      _CreateSubscriptionScreenState();
}

class _CreateSubscriptionScreenState extends State<CreateSubscriptionScreen> {
  var _subscription = new Subscription();
  final _formKey = GlobalKey<FormState>();
  final _renewal = Renewal();

  final GlobalKey<ScaffoldState> mScaffoldState =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kCreateSubscriptionBack,
      key: mScaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.kTitleAppbar),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Create Susbcription",
            style: TextStyle(
              color: AppColors.kTitleAppbar,
            )),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    _renewal.subscription = _subscription;

    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            _buildCard(),
            Expanded(
              child: _buildForm(context),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildCard() {
    return CardRow(
      onTap: () {},
      renewal: _renewal,
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
          _buildTextFieldName(),
          _buildTextFieldDescription(),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildTextFieldPrice(),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DateFieldWidget(
                    onSave: (val) => _subscription.firstBill =
                        DatesHelper.toDateFromString(val),
                    onChange: (val) {
                      _renewal.renewalAt = DatesHelper.toDateFromString(val);
                      _refresh();
                    },
                    hint: "First bill",
                    focusNode: _firstBill,
                    nextFocusNode: _renewalCycle,
                    inputAction: TextInputAction.done),
              ),
            ],
          ),
          Row(
            verticalDirection: VerticalDirection.down,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: TextFieldWidget(
                  onSave: (val) => _subscription.renewal = int.parse(val),
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
              _subscription.color = color;
              _renewal.subscription.color = color;
              _refresh();
            },
          ),
          _buildButtonSend(context),
        ],
      ),
    );
  }

  Widget _buildTextFieldName() {
    return TextFieldWidget(
        onSave: (val) => _subscription.name = val,
        onChange: (val) {
          _renewal.subscription.name = val;
          _refresh();
        },
        hint: "Name",
        focusNode: _name,
        nextFocusNode: _description,
        inputAction: TextInputAction.next);
  }

  Widget _buildTextFieldDescription() {
    return TextFieldWidget(
        onSave: (val) => _subscription.description = val,
        onChange: (val) {
          _renewal.subscription.description = val;
          _refresh();
        },
        hint: "Description",
        focusNode: _description,
        nextFocusNode: _price,
        inputAction: TextInputAction.next);
  }

  Widget _buildTextFieldPrice() {
    return TextFieldWidget(
        onSave: (val) => _subscription.price = double.parse(val),
        onChange: (val) {
          _renewal.subscription.price = double.parse(val);
          _refresh();
        },
        hint: "Price",
        focusNode: _price,
        nextFocusNode: null,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputAction: TextInputAction.next);
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

  void _refresh() {
    setState(() {});
  }

  _setRenewalPeriod() {
    _subscription.renewalPeriod = RenewalPeriod.enumOfString(_dropdownValue);
  }

  Widget _buildButtonSend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        height: 40,
        child: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: AppColors.kPrimaryColor,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _setRenewalPeriod();
              saveSubscription();
            }
          },
          child: Text(
            'Save',
            style: TextStyle(fontSize: 15, color: AppColors.kTitleButtonSave),
          ),
        ),
      ),
    );
  }

  void saveSubscription() async {
    final result = await SubscriptionInject.buildSubscriptionRepository()
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
