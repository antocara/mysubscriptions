import 'dart:math';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class SemiCircleChart extends StatefulWidget {
  SemiCircleChart({Key key, List<Payment> paymentsThisMonth})
      : _paymentsThisMonth = paymentsThisMonth,
        super(key: key);

  final List<Payment> _paymentsThisMonth;

  @override
  _SemiCircleChartState createState() => _SemiCircleChartState();
}

class _SemiCircleChartState extends State<SemiCircleChart> {
  List<Series<SubscriptionData, String>> _data;

  @override
  void initState() {
    _createData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget._paymentsThisMonth.length == 0) {
      return Container();
    }
    return _buildPieChart();
  }

  Widget _buildPieChart() {
    final marginsTop = MarginSpec.fixedPixel(0);
    final marginsBottom = MarginSpec.fixedPixel(10);
    return PieChart(
      _data,
      layoutConfig: LayoutConfig(
          topMarginSpec: marginsTop,
          rightMarginSpec: marginsTop,
          leftMarginSpec: marginsTop,
          bottomMarginSpec: marginsBottom),
      animate: true,
      defaultRenderer: ArcRendererConfig(
          strokeWidthPx: 0,
          arcWidth: 55,
          startAngle: 4 / 5 * pi,
          arcLength: 7 / 5 * pi,
          arcRendererDecorators: [new ArcLabelDecorator()]),
    );
  }

  void _createData() {
    _data = _createSerie();
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
        labelAccessorFn: (SubscriptionData row, _) => '€${row.price}',
        outsideLabelStyleAccessorFn: (SubscriptionData row, _) => TextStyleSpec(color: Color.white),
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
        b: subscription.color.blue, r: subscription.color.red, g: subscription.color.green);
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
