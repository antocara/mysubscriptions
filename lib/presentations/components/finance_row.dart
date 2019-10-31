import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/presentations/styles/dimens.dart';
import 'package:subscriptions/presentations/styles/text_styles.dart';

class FinanceRowData {
  FinanceRowData({this.title, this.amount, this.color});

  String title;
  double amount;
  Color color;
}

class FinanceRow extends StatefulWidget {
  FinanceRow({Key key, FinanceRowData data})
      : _data = data,
        super(key: key);

  final FinanceRowData _data;

  @override
  _FinanceRowState createState() => _FinanceRowState();
}

class _FinanceRowState extends State<FinanceRow> {
  final _key = new GlobalKey<_FinanceRowState>();
  double _widthSubscriptionRow = 0.00;

  @override
  initState() {
    super.initState();
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _calculateWidthRow();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildRow(context);
  }

  Widget _buildRow(BuildContext context) {
    return Stack(
      key: _key,
      children: <Widget>[
        _buildBackColorRow(),
        Container(
          color: widget._data.color.withOpacity(0.4),
          height: kFinanceRowHeight,
          margin: EdgeInsets.only(left: 0, right: 0),
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  widget._data.title,
                  style: kFinanceRowTitle,
                )),
                Text("€${widget._data.amount.toStringAsFixed(2)}",
                    style: kFinanceRowAmount)
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackColorRow() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: widget._data.color.withOpacity(0.8),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(25),
            topLeft: const Radius.circular(25),
          ),
        ),
        width: _widthSubscriptionRow * widget._data.amount,
        height: kFinanceRowHeight,
      ),
    );
  }

  void _calculateWidthRow() {
    final BuildContext context = _key.currentContext;
    final RenderBox box = context.findRenderObject();
    final width = box?.size?.width ?? 0;
    setState(() {
      _widthSubscriptionRow = width / (widget._data.amount.round() + 8);
    });
  }
}
