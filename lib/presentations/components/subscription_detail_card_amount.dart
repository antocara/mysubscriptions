import 'package:flutter/material.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;
import 'package:subscriptions/presentations/styles/text_styles.dart';

class SubscriptionDetailCardAmount extends StatelessWidget {
  SubscriptionDetailCardAmount(
      {Key key, String currentYearAmount, String totalAmount})
      : _currentYearAmount = currentYearAmount,
        _totalAmount = totalAmount,
        super(key: key);

  final String _currentYearAmount;
  final String _totalAmount;

  @override
  Widget build(BuildContext context) {
    return _buildCardAmount(context);
  }

  Widget _buildCardAmount(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.kBorderRadiusCard)),
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
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _buildCurrentYearAmount(context),
                    flex: 1,
                  ),
                  Expanded(
                    child: _buildTotalAmount(context),
                    flex: 1,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentYearAmount(BuildContext context) {
    return _buildAmountView(
        AppLocalizations.of(context).translate("amount_current_year"),
        "€$_currentYearAmount");
  }

  Widget _buildTotalAmount(BuildContext context) {
    return _buildAmountView(
        AppLocalizations.of(context).translate("total_amount"),
        "€$_totalAmount");
  }

  Widget _buildAmountView(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(title, style: kCardDetailAmountTitle),
        SizedBox(
          height: 10,
        ),
        Text(amount, style: kCardDetailAmount)
      ],
    );
  }
}
