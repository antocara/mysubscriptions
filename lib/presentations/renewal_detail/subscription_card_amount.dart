import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;

class SubscriptionCardAmount extends StatefulWidget {
  SubscriptionCardAmount({Key key, @required Renewal renewal})
      : _renewal = renewal,
        super(key: key);

  final Renewal _renewal;

  @override
  _SubscriptionCardAmountState createState() => _SubscriptionCardAmountState();
}

class _SubscriptionCardAmountState extends State<SubscriptionCardAmount> {
  var _colorTextSubTitles = AppColors.kTextCardDetail.withOpacity(.50);

  @override
  void initState() {
    _colorTextSubTitles = AppColors.kTextCardDetail.withOpacity(0.50);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardAmount();
  }

  Widget _buildCardAmount() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard)),
      margin: EdgeInsets.symmetric(
          vertical: 0, horizontal: AppDimens.kDefaultHorizontalMargin),
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
                    child: _buildCurrentYearAmount(),
                    flex: 1,
                  ),
                  Expanded(
                    child: _buildTotalAmount(),
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

  Widget _buildCurrentYearAmount() {
    return _buildAmountView("Amount Current Year", "€250.33");
  }

  Widget _buildTotalAmount() {
    return _buildAmountView("Total Amount", "€1340");
  }

  Widget _buildAmountView(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(title, style: TextStyle(color: _colorTextSubTitles, fontSize: 17)),
        SizedBox(
          height: 10,
        ),
        Text(amount,
            style: TextStyle(color: AppColors.kTextCardDetail, fontSize: 25))
      ],
    );
  }
}
