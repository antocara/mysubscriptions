import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/di/subscription_inject.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/renewal_period.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/components/WidgetsFormHelper/color_field_widget.dart';
import 'package:subscriptions/presentations/components/WidgetsFormHelper/date_field_widget.dart';
import 'package:subscriptions/presentations/components/WidgetsFormHelper/dismiss_keyboard_on_scroll.dart';
import 'package:subscriptions/presentations/components/WidgetsFormHelper/text_field_widget.dart';
import 'package:subscriptions/presentations/components/card_row.dart';
import 'package:subscriptions/presentations/components/app_bar_detail.dart';
import 'package:subscriptions/presentations/navigation_manager.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/text_styles.dart';

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
  void initState() {
    _renewal.subscription = _subscription;
    _renewal.subscription.isActive = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.kDefaultBackground, //AppColors.kDefaultBackground,
      key: mScaffoldState,
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    return AppBarDetail(
      title: AppLocalizations.of(context).translate("create_subscription"),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _buildCard(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: CardRow(
        onTap: () {},
        renewal: _renewal,
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

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 25.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              color: Colors.white),
          child: _buildInputs(context),
        ),
      ),
    );
  }

  Widget _buildInputs(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.00),
      child: DismissKeyboardOnScroll(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            _buildTextFieldName(context),
            _buildTextFieldDescription(context),
            _buildTextFieldPrice(context),
            _buildDateTextField(context),
            _buildRenewalTextField(context),
            _buildDropDown(),
            _buildColorCard(),
            _buildButtonSend(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFieldName(BuildContext context) {
    return TextFieldWidget(
      onSave: (val) => _subscription.name = val,
      onChange: (val) {
        _renewal.subscription.name = val;
        _refresh();
      },
      hint: AppLocalizations.of(context).translate("name"),
      focusNode: _name,
      nextFocusNode: _description,
      inputAction: TextInputAction.next,
      icons: Icons.chat,
    );
  }

  Widget _buildTextFieldDescription(BuildContext context) {
    return TextFieldWidget(
      onSave: (val) => _subscription.description = val,
      onChange: (val) {
        _renewal.subscription.description = val;
        _refresh();
      },
      hint: AppLocalizations.of(context).translate("description"),
      focusNode: _description,
      nextFocusNode: _price,
      inputAction: TextInputAction.next,
      icons: Icons.chat,
    );
  }

  Widget _buildTextFieldPrice(BuildContext context) {
    return TextFieldWidget(
      onSave: (val) => _subscription.price = double.parse(val),
      onChange: (val) {
        _renewal.subscription.price = double.parse(val);
        _refresh();
      },
      hint: AppLocalizations.of(context).translate("price"),
      focusNode: _price,
      nextFocusNode: null,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputAction: TextInputAction.next,
      icons: Icons.attach_money,
    );
  }

  Widget _buildDateTextField(BuildContext context) {
    return DateFieldWidget(
      onSave: (val) =>
          _subscription.firstBill = DatesHelper.toDateFromString(val),
      onChange: (val) {
        _renewal.renewalAt = DatesHelper.toDateFromString(val);
        _refresh();
      },
      hint: AppLocalizations.of(context).translate("first_bill"),
      focusNode: _firstBill,
      nextFocusNode: _renewalCycle,
      inputAction: TextInputAction.done,
      icons: Icons.date_range,
    );
  }

  Widget _buildRenewalTextField(BuildContext context) {
    return TextFieldWidget(
      onSave: (val) => _subscription.renewal = int.parse(val),
      hint: AppLocalizations.of(context).translate("renewal_cycle"),
      focusNode: _renewalCycle,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      nextFocusNode: _subscriptionColor,
      inputAction: TextInputAction.next,
      icons: Icons.update,
    );
  }

  Widget _buildDropDown() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.1),
      ),
      margin: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 0),
            child: Icon(
              Icons.next_week,
              color: AppColors.kPrimaryColor,
            ),
          ),
          Expanded(
            child: DropdownButton<String>(
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
              style: kInputFormContent,
              items: RenewalPeriod.renewalCyclesValues(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorCard() {
    return ColorFieldWidget(
      colorSelected: (Color color) {
        _subscription.color = color;
        _renewal.subscription.color = color;
        _refresh();
      },
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
        height: 45,
        child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: AppColors.kPrimaryColorDark,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _setRenewalPeriod();
              saveSubscription(context);
            }
          },
          child: Text(
            AppLocalizations.of(context).translate("create"),
            style: TextStyle(fontSize: 15, color: AppColors.kTitleButtonSave),
          ),
        ),
      ),
    );
  }

  void saveSubscription(BuildContext context) async {
    final result = await SubscriptionInject.buildSubscriptionRepository()
        .saveSubscription(_subscription);

    if (result) {
      showSnackBar(
        message: AppLocalizations.of(context).translate("subscription_saved"),
      );
      NavigationManager.popView(context);
    } else {
      showSnackBar(
        message:
            AppLocalizations.of(context).translate("error_saving_subscription"),
      );
    }
  }

  void showSnackBar({String message}) {
    final snackBar = new SnackBar(content: new Text(message));
    mScaffoldState.currentState.showSnackBar(snackBar);
  }
}
