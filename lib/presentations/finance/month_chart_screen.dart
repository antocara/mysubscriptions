import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/finance/chart_widgets/semi_circle_chart.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;

class MonthChartScreen extends StatefulWidget {
  @override
  _MonthChartScreenState createState() => _MonthChartScreenState();
}

class _MonthChartScreenState extends State<MonthChartScreen> {
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
                _buildAmount(projectSnap.data),
                SizedBox(
                  height: 10,
                ),
                _buildSubscriptionList(projectSnap.data)
              ],
            );
          }
        },
        future: _fetchRenewalsThisMonth(),
      ),
    );
  }

  Widget _buildAmount(List<Payment> payments) {
    return Container(
      alignment: Alignment(1.0, 1.0),
      margin: EdgeInsets.only(left: 30, right: 10),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: <Widget>[
        Text(
          "Expenses",
          style: TextStyle(color: AppColors.kTextCardDetail, fontSize: 15),
        ),
        Text(
          "€ ${_calculateThisMonthAmount(payments)}",
          style: TextStyle(color: AppColors.kTextCardDetail, fontSize: 25),
        ),
      ]),
    );
  }

  Widget _buildChart(List<Payment> data) {
    return Container(
      height: 200,
      child: SemiCircleChart(paymentsThisMonth: data),
    );
  }

  Widget _buildSubscriptionList(List<Payment> payments) {
    return Expanded(
      child: ListView.builder(
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final subscription = payments[index].subscription;
          return _buildRow(subscription);
        },
      ),
    );
  }

  Widget _buildRow(Subscription subscription) {
    return Stack(
      children: <Widget>[
        _buildBackColorRow(subscription),
        Container(
          color: subscription.color.withOpacity(0.4),
          height: 45,
          margin: EdgeInsets.only(left: 0, right: 0),
          child: Padding(
            padding: EdgeInsets.only(left: 30, right: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  subscription.name,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
                Text("€${subscription.price}",
                    style: TextStyle(color: Colors.white, fontSize: 16))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackColorRow(Subscription subscription) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
          color: subscription.color.withOpacity(0.6),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(20),
            topLeft: const Radius.circular(20),
          ),
        ),
        width: 10 * subscription.price,
        height: 45,
      ),
    );
  }

  double _calculateThisMonthAmount(List<Payment> payments) {
    return payments.map((payment) {
      return payment.subscription.price;
    }).fold(0.00, (current, next) {
      return current + next;
    });
  }

  Future<List<Payment>> _fetchRenewalsThisMonth() async {
    final DateTime now = DateTime.now();
    final firstDateThisMonth = DatesHelper.firstDayOfMonth(DateTime.now());
    final DateTime lastDayMonth =
        DatesHelper.lastDayOfMonth(DateTime(now.year, now.month));

    final result = await _paymentRepository.fetchAllRenewalsByMonth(
        firstDateThisMonth, lastDayMonth);
    result.sort((first, second) {
      return second.subscription.price.compareTo(first.subscription.price);
    });

    return result;
  }
}
