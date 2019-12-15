import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/renewal_period.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;
import 'package:subscriptions/presentations/styles/text_styles.dart';

class SubscriptionDetailCard extends StatelessWidget {
  SubscriptionDetailCard({Key key, @required Renewal renewal})
      : _renewal = renewal,
        super(key: key);

  final Renewal _renewal;

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.kBorderRadiusCard),
      ),
      margin: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: AppDimens.kDefaultHorizontalMargin,
      ),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTextName(),
            _separator(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                _buildTextPrice(),
                _buildTextPeriod(),
              ],
            ),
            _separator(15),
            Align(
                alignment: Alignment.centerLeft,
                child: _buildTextDescription(context)),
            _separator(15),
            Container(
              child: Row(
                children: <Widget>[
                  _buildTextFirstPayment(context),
                  Expanded(
                    child: Container(),
                  ),
                  _buildTextNextPayment(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextName() {
    return Text(_renewal.subscription.upperName,
        style: TextStyle(fontSize: 28, color: _renewal.subscription.color));
  }

  Widget _buildTextPrice() {
    return Text(
      _renewal.subscription.priceAtStringFormat,
      style: TextStyle(fontSize: 35, color: _renewal.subscription.color),
    );
  }

  Widget _buildTextPeriod() {
    final period = _renewal.subscription.renewalPeriod;
    final periodValue = RenewalPeriod.stringValueFromEnum(period).toLowerCase();
    return Text(
      "/$periodValue",
      style: TextStyle(fontSize: 25, color: _renewal.subscription.color),
    );
  }

  Widget _buildTextDescription(BuildContext context) {
    final description = _renewal.subscription.description ?? "";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text(AppLocalizations.of(context).translate("description"),
            style: TextStyle(
                color: AppColors.kTextCardDetail.withOpacity(0.50),
                fontSize: 13)),
        _separator(5),
        Text(description, style: kCardDescriptionTextStyle, maxLines: 2)
      ],
    );
  }

  Widget _buildTextFirstPayment(BuildContext context) {
    return _buildPaymentView(
        AppLocalizations.of(context).translate("first_payment_day"),
        _renewal.subscription.firstPaymentAtPretty ?? "");
  }

  Widget _buildTextNextPayment(BuildContext context) {
    return _buildPaymentView(
        AppLocalizations.of(context).translate("next_payment_day"),
        _renewal.renewalAtPretty ?? "");
  }

  Widget _buildPaymentView(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(title,
            style: TextStyle(
                color: AppColors.kTextCardDetail.withOpacity(0.50),
                fontSize: 15)),
        _separator(10),
        Text(amount, style: kCardDetailAmount)
      ],
    );
  }

  SizedBox _separator(double distance) {
    return SizedBox(
      height: distance,
    );
  }
}
