import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:subscriptions/presentations/styles/colors.dart';
import 'package:subscriptions/presentations/styles/dimens.dart';

class FinanceStickyHeader extends StatelessWidget {
  FinanceStickyHeader(
      {Key key, String title, String amount, List<Widget> childHeader})
      : _title = title,
        _amount = amount,
        _childHeader = childHeader,
        super(key: key);

  final String _title;
  final String _amount;
  final List<Widget> _childHeader;

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        height: kFinanceStickyHeaderRowHeight,
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
        children: _childHeader,
      ),
    );
  }
}
