import 'package:flutter/material.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/finance/chart_widgets/bar_chart_yearly.dart';
import 'package:subscriptions/presentations/finance/chart_widgets/pie_chart_this_month.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;

class FinanceHomeScreen extends StatefulWidget {
  @override
  _FinanceHomeScreenState createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen> {
  PaymentRepository _paymentRepository;

  @override
  void initState() {
    _paymentRepository = PaymentInject.buildPaymentRepository();
    _fetchRenewalsThisMonth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.kAppBarTitleDetail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Finance",
            style: TextStyle(
              color: AppColors.kAppBarTitleDetail,
            )),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: <Widget>[
        _buildCardAmount(),
        SizedBox(
          height: 10,
        ),
        _buildYearlyCard(),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget _buildCardAmount() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard)),
      margin: EdgeInsets.symmetric(
          vertical: 0, horizontal: AppDimens.defaultHorizontalMargin),
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _buildAmountView("This month"),
                    flex: 1,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountView(String title) {
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
                Row(children: <Widget>[
                  Text(title,
                      style: TextStyle(
                          color: AppColors.kTextCardDetail, fontSize: 20)),
                  SizedBox(
                    width: 15,
                  ),
                  Text("€ ${_calculateThisMonthAmount(projectSnap.data)}",
                      style: TextStyle(
                          color: AppColors.kTextCardDetail, fontSize: 30)),
                ]),
                PieChartThisMonth(
                  paymentsThisMonth: projectSnap.data,
                )
              ],
            );
          }
        },
        future: _fetchRenewalsThisMonth(),
      ),
    );
  }

  Widget _buildYearlyCard() {
    return Container(
      height: 350,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard)),
        margin: EdgeInsets.symmetric(
            vertical: 0, horizontal: AppDimens.defaultHorizontalMargin),
        elevation: 10,
        child: BarChartYearly(),
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
    return result;
  }
}
