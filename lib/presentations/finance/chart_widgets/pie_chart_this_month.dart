import 'dart:async';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/payment.dart';

import 'indicator.dart';

class PieChartThisMonth extends StatefulWidget {
  PieChartThisMonth({Key key, List<Payment> paymentsThisMonth})
      : _paymentsThisMonth = paymentsThisMonth,
        super(key: key);

  List<Payment> _paymentsThisMonth;

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartThisMonth> {
  StreamController<PieTouchResponse> pieTouchedResultStreamController;

  int touchedIndex;
  var _indicatorsWidgets = List<Widget>();

  @override
  void initState() {
    super.initState();

    _buildLegendIndicator();
    pieTouchedResultStreamController = StreamController();
    pieTouchedResultStreamController.stream.distinct().listen((details) {
      if (details == null) {
        return;
      }

      setState(() {
        if (details.touchInput is FlLongPressEnd) {
          touchedIndex = -1;
        } else {
          touchedIndex = details.touchedSectionPosition;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(
          height: 18,
        ),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: FlChart(
              chart: PieChart(
                PieChartData(
                    pieTouchData: PieTouchData(
                        touchResponseStreamSink:
                            pieTouchedResultStreamController.sink),
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 0,
                    centerSpaceRadius: 40,
                    sections: showingSections()),
              ),
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _indicatorsWidgets,
        ),
        const SizedBox(
          width: 28,
        ),
      ],
    );
  }

  void _buildLegendIndicator() {
    for (var payment in widget._paymentsThisMonth) {
      _indicatorsWidgets.add(Indicator(
        color: payment.subscription.color,
        text: payment.subscription.name,
        isSquare: true,
      )); // TODO: Whatever layout you need for each widget.
    }
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(widget._paymentsThisMonth.length, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      final payment = widget._paymentsThisMonth[i];

      return PieChartSectionData(
        color: payment.subscription.color,
        value: payment.subscription.price,
        title: "€ ${payment.subscription.price}",
        radius: radius,
        titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white),
      );
    });
  }
}
