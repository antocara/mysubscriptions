import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class BarChartYearly extends StatefulWidget {
  BarChartYearly({Key key, List<Payment> paymentList})
      : _paymentList = paymentList,
        super(key: key);

  final List<Payment> _paymentList;

  @override
  _BarChartYearlyState createState() => _BarChartYearlyState();
}

class _BarChartYearlyState extends State<BarChartYearly> {
  List<Series<SubscriptionData, String>> _data;

  @override
  void initState() {
    _createData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return BarChart(
      _data,
      animate: true,
      barGroupingType: BarGroupingType.stacked,
      vertical: true,
      domainAxis: OrdinalAxisSpec(
          renderSpec: SmallTickRendererSpec(
              minimumPaddingBetweenLabelsPx: 0,
              // Tick and Label styling here.
              labelStyle: TextStyleSpec(
                  fontSize: 15, // size in Pts.
                  color: MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: LineStyleSpec(color: MaterialPalette.black))),
      primaryMeasureAxis: NumericAxisSpec(
          renderSpec: GridlineRendererSpec(

              // Tick and Label styling here.
              labelStyle: TextStyleSpec(
                  fontSize: 18, // size in Pts.
                  color: MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: LineStyleSpec(color: MaterialPalette.white))),
    );
  }

  void _createData() {
    _data = widget._paymentList
        .map((payment) {
          return payment.subscription;
        })
        .toSet()
        .toList()
        .map((subscription) {
          return _createSerie(subscription);
        })
        .toList();
  }

  Series<SubscriptionData, String> _createSerie(Subscription subscription) {
    return Series<SubscriptionData, String>(
      id: subscription.name,
      seriesColor: _createColor(subscription),
      domainFn: (SubscriptionData data, _) {
        return data.month;
      },
      measureFn: (SubscriptionData data, _) {
        return data.price;
      },
      outsideLabelStyleAccessorFn: (SubscriptionData row, _) =>
          TextStyleSpec(color: Color.white),
      data: _createSerieData(subscription),
    );
  }

  List<SubscriptionData> _createSerieData(Subscription subscription) {
    return widget._paymentList.where((payment) {
      return payment.subscription.id == subscription.id;
    }).map((payment) {
      return SubscriptionData(
          DatesHelper.parseNumberMonthToName(payment.renewalAt.month),
          payment.subscription.price);
    }).toList();
  }

  Color _createColor(Subscription subscription) {
    return Color(
        b: subscription.color.blue,
        r: subscription.color.red,
        g: subscription.color.green);
  }
}

class SubscriptionData {
  final String month;
  final double price;

  SubscriptionData(this.month, this.price);
}
