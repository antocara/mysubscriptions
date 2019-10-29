import 'dart:collection';

import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/domain/di/bloc_inject.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/components/finance_amount.dart';
import 'package:subscriptions/presentations/components/finance_row.dart';
import 'package:subscriptions/presentations/components/finance_sticky_header.dart';
import 'package:subscriptions/presentations/finance/chart_widgets/bar_chart_yearly.dart';

class YearChartScreen extends StatefulWidget {
  @override
  _YearChartScreenState createState() => _YearChartScreenState();
}

class _YearChartScreenState extends State<YearChartScreen> {
  final _bloc = BlocInject.buildFinanceBloc();

  @override
  void initState() {
    _bloc.fetchRenewalsUntilToday();
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
                      _buildSeparator(20),
                      FinanceAmount(payments: projectSnap.data),
                      _buildSeparator(10),
                      _buildSubscriptionList(projectSnap.data)
                    ],
                  ),
                ),
              ],
            );
          }
        },
        stream: _bloc.paymentsUntilToday,
      ),
    );
  }

  Widget _buildSeparator(double distance) {
    return SizedBox(
      height: distance,
    );
  }

  Widget _buildChart(List<Payment> data) {
    return Container(
      height: 200,
      child: BarChartYearly(
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
                amount: _calculateAmountByMonth(headerData[keys[index]]),
                childHeader: _buildMonthPayments(headerData[keys[index]]),
              );
            },
          );
        }
      },
      future: _groupData(data),
    );
  }

  List<Widget> _buildMonthPayments(List<Payment> data) {
    return data.map((payment) {
      final subscription = payment.subscription;
      final rowData = FinanceRowData(
          title: subscription.name,
          color: subscription.color,
          amount: subscription.price);
      return FinanceRow(data: rowData);
    }).toList();
  }

  String _calculateAmountByMonth(List<Payment> data) {
    return data.fold(0, (initialValue, payment) {
      return initialValue + payment.subscription.price;
    }).toString();
  }

  Future<Map<String, List<Payment>>> _groupData(List<Payment> result) async {
    return groupBy(result, (Payment obj) {
      return DatesHelper.toStringWithMonthAndYear(obj.renewalAt);
    });
  }
}
