import 'package:charts_flutter/flutter.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/amount_payments_year.dart';
import 'package:subscriptions/data/entities/subscription.dart';

class BarChartTotal extends StatefulWidget {
  BarChartTotal({Key key, List<AmountPaymentsYear> paymentList})
      : _paymentList = paymentList,
        super(key: key);

  final List<AmountPaymentsYear> _paymentList;

  @override
  _BarChartTotalState createState() => _BarChartTotalState();
}

class _BarChartTotalState extends State<BarChartTotal> {
  List<Series<AmountPaymentsYear, String>> _data;

  @override
  void initState() {
    _createData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new BarChart(
      _data,
      animate: true,
      barGroupingType: BarGroupingType.stacked,
      vertical: true,
    );
  }

  void _createData() {
    final grouped = groupBy(widget._paymentList, (AmountPaymentsYear obj) {
      return obj.year;
    });

    var data = List<Series<AmountPaymentsYear, String>>();
    grouped.forEach((year, payments) {
      final serie = _createSerie(payments);
      data.add(serie);
    });

    _data = data;
  }

  Series<AmountPaymentsYear, String> _createSerie(
      List<AmountPaymentsYear> paymentsYear) {
    return Series<AmountPaymentsYear, String>(
      id: paymentsYear[0].year,
      colorFn: (AmountPaymentsYear data, _) {
        return _createColor(data.subscription);
      },
      domainFn: (AmountPaymentsYear data, _) {
        return paymentsYear[0].year;
      },
      measureFn: (AmountPaymentsYear data, _) {
        return data.amount;
      },
      data: paymentsYear,
    );
  }

  Color _createColor(Subscription subscription) {
    return Color(
        b: subscription.color.blue,
        r: subscription.color.red,
        g: subscription.color.green);
  }
}
