import 'dart:collection';

import "package:collection/collection.dart";
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/components/finance_amount.dart';
import 'package:subscriptions/presentations/components/finance_row.dart';
import 'package:subscriptions/presentations/finance/chart_widgets/bar_chart_yearly.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;

class YearChartScreen extends StatefulWidget {
  @override
  _YearChartScreenState createState() => _YearChartScreenState();
}

class _YearChartScreenState extends State<YearChartScreen> {
  PaymentRepository _paymentRepository;

  @override
  void initState() {
    _paymentRepository = PaymentInject.buildPaymentRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Widget _buildBody() {
    return Center(
      child: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none ||
              !projectSnap.hasData) {
            return Container();
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildChart(projectSnap.data),
                SizedBox(
                  height: 20,
                ),
                FinanceAmount(payments: projectSnap.data),
                SizedBox(
                  height: 10,
                ),
                _buildSubscriptionList(projectSnap.data)
              ],
            );
          }
        },
        future: _fetchRenewalsUntilToday(),
      ),
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
    return Expanded(
      child: FutureBuilder(
        builder: (context, projectSnap) {
          if (projectSnap.connectionState == ConnectionState.none ||
              !projectSnap.hasData) {
            return Container();
          } else {
            return ListView.builder(
              itemCount: projectSnap.data.length,
              itemBuilder: (context, index) {
                final headerData =
                    projectSnap.data as LinkedHashMap<String, List<Payment>>;
                final keys = headerData.keys.toList();

                return StickyHeader(
                  header: Container(
                    height: 50.0,
                    color: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            keys[index],
                            style:
                                const TextStyle(color: AppColors.kWhiteColor),
                          ),
                        ),
                        Text(
                          "€ ${_calculateAmountByMonth(headerData[keys[index]])}",
                          style: const TextStyle(color: AppColors.kWhiteColor),
                        ),
                      ],
                    ),
                  ),
                  content: Column(
                    children: _buildMonthPayments(
                        keys[index], headerData[keys[index]]),
                  ),
                );
              },
            );
          }
        },
        future: _groupData(data),
      ),
    );
  }

  List<Widget> _buildMonthPayments(String key, List<Payment> data) {
    return data.map((payment) {
      return FinanceRow(subscription: payment.subscription);
    }).toList();
  }

  String _calculateAmountByMonth(List<Payment> data) {
    return data.fold(0, (initialValue, payment) {
      return initialValue + payment.subscription.price;
    }).toString();
  }

  Future<List<Payment>> _fetchRenewalsUntilToday() async {
    final DateTime now = DateTime.now();
    final firstDateYear = DatesHelper.firstDayOfYear(DateTime.now());

    final result =
        await _paymentRepository.fetchAllRenewalsByMonth(firstDateYear, now);

    return result;
  }

  Future<Map<String, List<Payment>>> _groupData(List<Payment> result) async {
    return groupBy(result, (Payment obj) {
      return DatesHelper.toStringWithMonthAndYear(obj.renewalAt);
    });
  }
}
