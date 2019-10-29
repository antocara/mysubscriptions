import 'dart:collection';

import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/domain/di/bloc_inject.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/components/finance_amount.dart';
import 'package:subscriptions/presentations/components/finance_row.dart';
import 'package:subscriptions/presentations/components/finance_sticky_header.dart';
import 'package:subscriptions/presentations/finance/chart_widgets/bar_chart_total.dart';

class TotalChartScreen extends StatefulWidget {
  @override
  _TotalChartScreenState createState() => _TotalChartScreenState();
}

class _TotalChartScreenState extends State<TotalChartScreen> {
  final _bloc = BlocInject.buildFinanceBloc();

  @override
  void initState() {
    _bloc.fetchTotalRenewals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Center(
      child: StreamBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none ||
              !projectSnap.hasData) {
            return Container();
          } else {
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildChart(projectSnap.data),
                      FinanceAmount(payments: projectSnap.data),
                      SizedBox(height: 10),
                      _buildSubscriptionList(projectSnap.data)
                    ],
                  ),
                ),
              ],
            );
          }
        },
        stream: _bloc.paymentsTotal,
      ),
    );
  }

  Widget _buildChart(List<Payment> data) {
    return Container(
      height: 200,
      child: BarChartTotal(
        paymentList: data,
      ),
    );
  }

  Widget _buildSubscriptionList(List<Payment> data) {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none ||
            !projectSnap.hasData) {
          return Container();
        } else {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              final headerData =
                  projectSnap.data as LinkedHashMap<String, List<Payment>>;
              final keys = headerData.keys.toList();

              return FinanceStickyHeader(
                title: keys[index],
                amount: _calculateAmountByMonth(headerData[keys[index]])
                    .toStringAsFixed(2),
                childHeader: _buildYearsPayments(data),
              );
            },
          );
        }
      },
      future: _groupData(data),
    );
  }

  List<Widget> _buildYearsPayments(List<Payment> data) {
    var subscriptions = LinkedHashMap<double, Payment>();

    groupBy(data, (Payment obj) {
      return obj.subscription.name;
    }).forEach((key, payments) {
      final double amount = payments.fold(0, (initial, current) {
        return initial + current.subscription.price;
      });
      subscriptions[amount] = payments[0];
    });

    var sortedKeys = subscriptions.keys.toList(growable: false)
      ..sort((k1, k2) => subscriptions[k1].compareTo(subscriptions[k2]));
    LinkedHashMap sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => subscriptions[k]);

    return sortedMap.keys.toList().map((key) {
      final Subscription subscription = sortedMap[key].subscription;
      final rowData = FinanceRowData(
          title: subscription.name, color: subscription.color, amount: key);
      return FinanceRow(data: rowData);
    }).toList();
  }

  double _calculateAmountByMonth(List<Payment> data) {
    return data.fold(0.00, (initialValue, payment) {
      return initialValue + payment.subscription.price;
    });
  }

  Future<Map<String, List<Payment>>> _groupData(List<Payment> result) async {
    return groupBy(result, (Payment obj) {
      return DatesHelper.toStringWithYear(obj.renewalAt);
    });
  }
}
