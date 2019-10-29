import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/presentations/components/finance_row.dart';
import 'package:subscriptions/presentations/styles/colors.dart';

class FinanceStickyHeader extends StatelessWidget {
  FinanceStickyHeader(
      {Key key, String title, String amount, List<Payment> paymentsMonth})
      : _title = title,
        _amount = amount,
        _paymentsMonth = paymentsMonth,
        super(key: key);

  final String _title;
  final String _amount;
  final List<Payment> _paymentsMonth;

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        height: 40.0,
        color: Colors.deepPurple,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                _title,
                style: const TextStyle(fontSize: 25, color: kWhiteColor),
              ),
            ),
            Text(
              "€ $_amount",
              style: const TextStyle(fontSize: 25, color: kWhiteColor),
            ),
          ],
        ),
      ),
      content: Column(
        children: _buildMonthPayments(_paymentsMonth),
      ),
    );
  }

  List<Widget> _buildMonthPayments(List<Payment> data) {
    return data.map((payment) {
      return FinanceRow(subscription: payment.subscription);
    }).toList();
  }
}
