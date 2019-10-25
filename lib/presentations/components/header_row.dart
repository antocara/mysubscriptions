import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;
import 'package:subscriptions/presentations/styles/text_styles.dart'
    as AppTextStyles;

class HeaderRow extends StatefulWidget {
  HeaderRow({Key key, this.title, this.amount}) : super(key: key);

  final String title;
  final double amount;

  @override
  _HeaderRowState createState() => _HeaderRowState();
}

class _HeaderRowState extends State<HeaderRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 0,
        horizontal: AppDimens.kDefaultHorizontalMargin,
      ),
      height: 60,
      child: Row(
        children: <Widget>[
          _buildTitleText(),
          Expanded(
            child: Container(),
          ),
          _buildAmountTitleText(),
        ],
      ),
    );
  }

  Text _buildTitleText() {
    return Text(
      widget.title,
      style: AppTextStyles.kTitleHeaderRow,
    );
  }

  Text _buildAmountTitleText() {
    return Text(
      "€ ${widget.amount ?? 0.00}",
      style: AppTextStyles.kSubTitleHeaderRow,
    );
  }
}
