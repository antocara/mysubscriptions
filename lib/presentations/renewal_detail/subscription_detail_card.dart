import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/entities/renewal_period.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;

class SubscriptionDetailCard extends StatefulWidget {
  SubscriptionDetailCard({Key key, @required Renewal renewal})
      : _renewal = renewal,
        super(key: key);

  final Renewal _renewal;

  @override
  _SubscriptionDetailCardState createState() => _SubscriptionDetailCardState();
}

class _SubscriptionDetailCardState extends State<SubscriptionDetailCard> {
  var _colorTextTitles = AppColors.kTextCardDetail;
  var _colorTextSubTitles = AppColors.kTextCardDetail.withOpacity(.50);

  @override
  void initState() {
    _colorTextTitles = widget._renewal.subscription.color;
    _colorTextSubTitles = AppColors.kTextCardDetail.withOpacity(0.50);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Widget _buildCard() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.kBorderRadiusCard)),
      margin: EdgeInsets.symmetric(
          vertical: 0, horizontal: AppDimens.kDefaultHorizontalMargin),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTextName(),
            _buildSeparator(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: <Widget>[
                _buildTextPrice(),
                _buildTextPeriod(),
              ],
            ),
            _buildSeparator(),
            Align(
                alignment: Alignment.centerLeft,
                child: _buildTextDescription()),
            _buildSeparator(),
            Container(
              child: Row(
                children: <Widget>[
                  _buildTextFirstPayment(),
                  Expanded(
                    child: Container(),
                  ),
                  _buildTextNextPayment(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextName() {
    return Text(widget._renewal.subscription.upperName,
        style: TextStyle(fontSize: 28, color: _colorTextTitles));
  }

  Widget _buildTextPrice() {
    return Text(
      widget._renewal.subscription.priceAtStringFormat,
      style: TextStyle(fontSize: 35, color: _colorTextTitles),
    );
  }

  Widget _buildTextPeriod() {
    final period = widget._renewal.subscription.renewalPeriod;
    final periodValue = RenewalPeriod.stringValueFromEnum(period).toLowerCase();
    return Text(
      "/$periodValue",
      style: TextStyle(fontSize: 25, color: _colorTextTitles),
    );
  }

  Widget _buildTextDescription() {
    final description = widget._renewal.subscription.description ?? "";
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: <Widget>[
        Text("Description:",
            style: TextStyle(color: _colorTextSubTitles, fontSize: 13)),
        SizedBox(
          width: 5,
        ),
        Text(
          description,
          style: TextStyle(color: AppColors.kTextCardDetail, fontSize: 20),
          maxLines: 2,
        )
      ],
    );
  }

  Widget _buildTextFirstPayment() {
    return _buildPaymentView("First Payment day:",
        widget._renewal.subscription.firstPaymentAtPretty ?? "");
  }

  Widget _buildTextNextPayment() {
    return _buildPaymentView(
        "Next Payment day:", widget._renewal.renewalAtPretty ?? "");
  }

  Widget _buildPaymentView(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(title, style: TextStyle(color: _colorTextSubTitles, fontSize: 15)),
        SizedBox(
          height: 10,
        ),
        Text(amount,
            style: TextStyle(color: AppColors.kTextCardDetail, fontSize: 20))
      ],
    );
  }

  SizedBox _buildSeparator() {
    return SizedBox(
      height: 15,
    );
  }
}
