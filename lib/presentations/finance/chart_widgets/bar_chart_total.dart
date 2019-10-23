import 'package:charts_flutter/flutter.dart';
import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class BarChartTotal extends StatefulWidget {
  BarChartTotal({Key key, List<Payment> paymentList})
      : _paymentList = paymentList,
        super(key: key);

  List<Payment> _paymentList;

  @override
  _BarChartTotalState createState() => _BarChartTotalState();
}

class _BarChartTotalState extends State<BarChartTotal> {
  List<Series<Subscription, String>> _data;

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
    final grouped = groupBy(widget._paymentList, (Payment obj) {
      return DatesHelper.toStringWithYear(obj.renewalAt);
    });

    var data = List<Series<Subscription, String>>();

    grouped.forEach((key, payments) {
      final amount = payments.fold(0, (initial, current) {
        return initial + current.subscription.price;
      });
      final filteredList = _filterDistinctSubscriptions(payments);
      data.add(_createSerie(key, filteredList, amount));
    });

    _data = data;
  }

  List<Subscription> _filterDistinctSubscriptions(List<Payment> payments) {
    final distincts = Set<Subscription>();
    final unique = payments
        .where((payment) => distincts.add(payment.subscription))
        .toList();
    return distincts.toList();
  }

  Series<Subscription, String> _createSerie(
      String year, List<Subscription> data, double amount) {
    return Series<Subscription, String>(
      id: year,
      colorFn: (Subscription data, _) {
        return _createColor(data);
      },
      domainFn: (Subscription data, _) {
        return year;
      },
      measureFn: (Subscription data, _) {
        return data.price;
      },
      data: data,
    );
  }

//  List<Payment> _createSerieData(Subscription subscription) {
//    return widget._paymentList.where((payment) {
//      return payment.subscription.id == subscription.id;
//    }).map((payment) {
//      return SubscriptionData(
//          "${payment.renewalAt.year}", payment.subscription.price);
//    }).toList();
//  }

  Color _createColor(Subscription subscription) {
    return Color(
        b: subscription.color.blue,
        r: subscription.color.red,
        g: subscription.color.green);
  }
}

//class SubscriptionData {
//  final String year;
//  final double price;
//
//  SubscriptionData(this.year, this.price);
//}
