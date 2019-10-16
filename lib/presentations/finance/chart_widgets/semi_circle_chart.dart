import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart' as prefix1;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/presentations/styles/dimens.dart';

class SemiCircleChart extends StatefulWidget {
  SemiCircleChart({Key key, List<Payment> paymentsThisMonth})
      : _paymentsThisMonth = paymentsThisMonth,
        super(key: key);

  List<Payment> _paymentsThisMonth;

  @override
  _SemiCircleChartState createState() => _SemiCircleChartState();
}

class _SemiCircleChartState extends State<SemiCircleChart> {
  List<Series<SubscriptionData, String>> _data;
  List<Widget> _legend;

  @override
  void initState() {
    _createData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return prefix1.Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildPieChart(),
        Expanded(child: _buidlLegend()),
      ],
    );
  }

  Widget _buidlLegend() {
    return Padding(
      padding: const EdgeInsets.all(kDefaultHorizontalMargin),
      child: Column(
        mainAxisAlignment: prefix1.MainAxisAlignment.center,
        children: _legend,
      ),
    );
  }

  Widget _buildPieChart() {
    return Container(
      height: 200,
      width: 200,
      child: PieChart(_data,
          animate: true,
          defaultRenderer: ArcRendererConfig(
            arcWidth: 35,
            arcRendererDecorators: [
              ArcLabelDecorator(),
            ],
          )),
    );
  }

  void _createData() {
    _data = _createSerie();
    _buildLegend();
  }

  List<Series<SubscriptionData, String>> _createSerie() {
    return [
      Series<SubscriptionData, String>(
        id: 'payments',
        domainFn: (SubscriptionData data, _) {
          return "${data.id}";
        },
        measureFn: (SubscriptionData data, _) {
          return data.price;
        },
        colorFn: (SubscriptionData data, _) {
          return data.color;
        },
        labelAccessorFn: (SubscriptionData data, _) {
          return data.price.toString();
        },
        data: _createSerieData(),
      )
    ];
  }

  List<SubscriptionData> _createSerieData() {
    return widget._paymentsThisMonth.map((payment) {
      return SubscriptionData(
          id: payment.id,
          name: payment.subscription.name,
          price: payment.subscription.price,
          color: _createColor(payment.subscription));
    }).toList();
  }

  Color _createColor(Subscription subscription) {
    return Color(
        b: subscription.color.blue,
        r: subscription.color.red,
        g: subscription.color.green);
  }

  void _buildLegend() {
    _legend = widget._paymentsThisMonth
        .map((payment) {
          return payment.subscription;
        })
        .toSet()
        .toList()
        .map((subscription) {
          return Chip(
            elevation: 8,
            backgroundColor: subscription.color,
            label: Text(
              subscription.name,
              style: TextStyle(color: Colors.white),
            ),
          );
        })
        .toList();
  }
}

/// Sample data type.
class SubscriptionData {
  final int id;
  final String name;
  final double price;
  final Color color;

  SubscriptionData({this.id, this.name, this.price, this.color});
}
