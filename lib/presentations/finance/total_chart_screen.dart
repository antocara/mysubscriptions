import 'dart:collection';

import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/amount_payments_year.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/domain/di/bloc_inject.dart';
import 'package:subscriptions/presentations/components/finance_amount.dart';
import 'package:subscriptions/presentations/components/finance_row.dart';
import 'package:subscriptions/presentations/components/finance_sticky_header.dart';
import 'package:subscriptions/presentations/components/chart_widgets/bar_chart_total.dart';

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
                      _calculateAmount(projectSnap.data),
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

  Widget _buildChart(List<AmountPaymentsYear> data) {
    return Container(
      height: 200,
      child: BarChartTotal(
        paymentList: data,
      ),
    );
  }

  Widget _calculateAmount(List<AmountPaymentsYear> data) {
    final payments = data.map((amountPayment) {
      final subscription = Subscription(price: amountPayment.amount);
      return Payment(subscription: subscription);
    }).toList();
    return FinanceAmount(payments: payments);
  }

  Widget _buildSubscriptionList(List<AmountPaymentsYear> data) {
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
              final headerData = projectSnap.data
                  as LinkedHashMap<String, List<AmountPaymentsYear>>;
              final keys = headerData.keys.toList();

              return FinanceStickyHeader(
                title: keys[index],
                amount: _calculateAmountByYear(headerData[keys[index]])
                    .toStringAsFixed(2),
                childHeader: _buildYearsPayments(headerData[keys[index]]),
              );
            },
          );
        }
      },
      future: _groupData(data),
    );
  }

  List<Widget> _buildYearsPayments(List<AmountPaymentsYear> data) {
    data.sort((first, second) => second.amount.compareTo(first.amount));
    return data.map((amountPayment) {
      final rowData = FinanceRowData(
          title: amountPayment.subscription.name,
          color: amountPayment.subscription.color,
          amount: amountPayment.amount);
      return FinanceRow(data: rowData);
    }).toList();
  }

  double _calculateAmountByYear(List<AmountPaymentsYear> data) {
    return data.fold(0.00, (initialValue, amountPayment) {
      return initialValue + amountPayment.amount;
    });
  }

  Future<Map<String, List<AmountPaymentsYear>>> _groupData(
      List<AmountPaymentsYear> result) async {
    return groupBy(result, (AmountPaymentsYear obj) {
      return obj.year;
    });
  }

  @override
  void dispose() {
    _bloc.disposed();
    super.dispose();
  }
}
