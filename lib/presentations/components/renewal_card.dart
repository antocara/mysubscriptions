import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;
import 'package:subscriptions/presentations/styles/text_styles.dart';

class RenewalCard extends StatelessWidget {
  RenewalCard({Key key, @required Renewal renewal})
      : _renewal = renewal,
        super(key: key);

  final Renewal _renewal;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.kBorderRadiusCard)),
      margin: EdgeInsets.symmetric(
          vertical: 0, horizontal: AppDimens.kDefaultHorizontalMargin),
      elevation: 10,
      color: _renewal.subscription.color ?? Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _buildCardContent(context),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildTitleSection(),
        SizedBox(
          height: 5,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: _buildDescriptionSection(),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: _buildPaymentDaySection(context),
        ),
      ],
    );
  }

  Widget _buildTitleSection() {
    return Row(
      children: <Widget>[
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            _renewal.subscription.name ?? "",
            style: kCardTitle,
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Text(_renewal.subscription.priceAtStringFormat, style: kCardPrice),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Text(_renewal.subscription.description ?? "",
        style: kCardDescriptionTextStyle, maxLines: 2);
  }

  Widget _buildPaymentDaySection(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(AppLocalizations.of(context).translate("payment_day"),
                style: kCardPaymentDayTitle),
            SizedBox(
              height: 5,
            ),
            Text(_renewal.renewalAtPretty ?? "", style: kCardPaymentDay),
          ],
        ),
        Expanded(
          child: Container(),
        ),
        _buildCircleAvatar(),
      ],
    );
  }

  Widget _buildCircleAvatar() {
    return CircleAvatar(
      foregroundColor: _renewal.subscription.color ?? AppColors.kWhiteColor,
      backgroundColor: AppColors.kWhiteColor,
      child: Text(_renewal.subscription.nameChars),
    );
  }
}
