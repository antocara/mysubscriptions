import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/components/finance_row.dart';
import 'package:subscriptions/presentations/finance/chart_widgets/semi_circle_chart.dart';
import 'package:subscriptions/presentations/styles/text_styles.dart';

class FinanceMonthScreen extends StatefulWidget {
  @override
  _FinanceMonthScreenState createState() => _FinanceMonthScreenState();
}

class _FinanceMonthScreenState extends State<FinanceMonthScreen> {
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
            return _buildScrollWidgets(projectSnap.data);
          }
        },
        future: _fetchRenewalsThisMonth(),
      ),
    );
  }

  Widget _buildScrollWidgets(List<Payment> data) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _buildChart(data),
              _buildAmount(data),
              _buildSubscriptionList(data)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmount(List<Payment> payments) {
    return Container(
      alignment: Alignment(1.0, 1.0),
      margin: EdgeInsets.only(left: 30, right: 16, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(AppLocalizations.of(context).translate("expenses"),
              style: kMonthAmountTitle),
          Text(
            "€ ${_calculateThisMonthAmount(payments)}",
            style: kMonthAmount,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<Payment> data) {
    return Container(
      height: 200,
      child: SemiCircleChart(paymentsThisMonth: data),
    );
  }

  Widget _buildSubscriptionList(List<Payment> payments) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final subscription = payments[index].subscription;
        return FinanceRow(subscription: subscription);
      },
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
