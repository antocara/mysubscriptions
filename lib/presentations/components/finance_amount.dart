import 'package:flutter/material.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/presentations/styles/text_styles.dart';

class FinanceAmount extends StatelessWidget {
  FinanceAmount({Key key, List<Payment> payments})
      : _payments = payments,
        super(key: key);

  final List<Payment> _payments;

  @override
  Widget build(BuildContext context) {
    return _buildAmount(context);
  }

  Widget _buildAmount(BuildContext context) {
    return Container(
      alignment: Alignment(1.0, 1.0),
      margin: EdgeInsets.only(left: 30, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(AppLocalizations.of(context).translate("expenses"),
              style: kMonthAmountTitle),
          Text(
            "€ ${_calculateThisMonthAmount(_payments)}",
            style: kMonthAmount,
          ),
        ],
      ),
    );
  }

  double _calculateThisMonthAmount(List<Payment> payments) {
    return payments.map((payment) {
      return payment.subscription.price;
    }).fold(0.00, (current, next) {
      return current + next;
    });
  }
}
