import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix1;

class BarChartYearly extends StatefulWidget {
  @override
  _BarChartYearlyState createState() => _BarChartYearlyState();
}

class _BarChartYearlyState extends State<BarChartYearly> {
  List<Series> seriesList;

  @override
  void initState() {
    seriesList = _createSampleData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // For horizontal bar charts, set the [vertical] flag to false.
    return new BarChart(
      seriesList,
      animate: true,
      barGroupingType: BarGroupingType.stacked,
      vertical: true,
    );
  }

  /// Create series list with multiple series
  List<Series<OrdinalSales, String>> _createSampleData() {
    final desktopSalesData = [
      new OrdinalSales('Ene', 5),
      new OrdinalSales('Feb', 25),
      new OrdinalSales('Mar', 40),
      new OrdinalSales('Abr', 15),
      new OrdinalSales('May', 5),
      new OrdinalSales('Jun', 25),
      new OrdinalSales('Jul', 40),
      new OrdinalSales('Ago', 15),
      new OrdinalSales('Sep', 5),
      new OrdinalSales('Oct', 25),
      new OrdinalSales('Nov', 40),
      new OrdinalSales('Dic', 15),
    ];

    final tableSalesData = [
      new OrdinalSales('Ene', 5),
      new OrdinalSales('Feb', 25),
      new OrdinalSales('Mar', 40),
      new OrdinalSales('Abr', 15),
      new OrdinalSales('May', 5),
      new OrdinalSales('Jun', 25),
      new OrdinalSales('Jul', 40),
      new OrdinalSales('Ago', 15),
      new OrdinalSales('Sep', 5),
      new OrdinalSales('Oct', 25),
      new OrdinalSales('Nov', 40),
      new OrdinalSales('Dic', 15),
    ];

    final mobileSalesData = [
      new OrdinalSales('Ene', 5),
      new OrdinalSales('Feb', 25),
      new OrdinalSales('Mar', 40),
      new OrdinalSales('Abr', 15),
      new OrdinalSales('May', 5),
      new OrdinalSales('Jun', 25),
      new OrdinalSales('Jul', 40),
      new OrdinalSales('Ago', 15),
      new OrdinalSales('Sep', 5),
      new OrdinalSales('Oct', 25),
      new OrdinalSales('Nov', 40),
      new OrdinalSales('Dic', 15),
    ];

    final mobileSalesData2 = [
      new OrdinalSales('Ene', 5),
      new OrdinalSales('Feb', 25),
      new OrdinalSales('Mar', 40),
      new OrdinalSales('Abr', 15),
      new OrdinalSales('May', 5),
      new OrdinalSales('Jun', 25),
      new OrdinalSales('Jul', 40),
      new OrdinalSales('Ago', 15),
      new OrdinalSales('Sep', 5),
      new OrdinalSales('Oct', 25),
      new OrdinalSales('Nov', 40),
      new OrdinalSales('Dic', 15),
    ];

    return [
      new Series<OrdinalSales, String>(
        id: 'Desktop',
        seriesColor: Color(
            b: prefix1.Colors.green[100].blue,
            r: prefix1.Colors.green[100].red,
            g: prefix1.Colors.green[100].green),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: desktopSalesData,
      ),
      new Series<OrdinalSales, String>(
        id: 'Tablet',
        seriesColor: Color(
            b: prefix1.Colors.green[200].blue,
            r: prefix1.Colors.green[200].red,
            g: prefix1.Colors.green[200].green),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: tableSalesData,
      ),
      new Series<OrdinalSales, String>(
        id: 'Mobile',
        seriesColor: Color(
            b: prefix1.Colors.green[300].blue,
            r: prefix1.Colors.green[300].red,
            g: prefix1.Colors.green[300].green),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData,
      ),
      new Series<OrdinalSales, String>(
        id: 'Mobile2',
        seriesColor: Color(
            b: prefix1.Colors.green[400].blue,
            r: prefix1.Colors.green[400].red,
            g: prefix1.Colors.green[400].green),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: mobileSalesData2,
      ),
    ];
  }
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;

  OrdinalSales(this.year, this.sales);
}
