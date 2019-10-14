import 'package:flutter/material.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/data/repositories/renewal_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;

class FinanceHomeScreen extends StatefulWidget {
  @override
  _FinanceHomeScreenState createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen> {
  PaymentRepository _paymentRepository;
  List<Payment> _paymentsThisMonth = List<Payment>();

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
    return Column(
      children: <Widget>[
        _buildCardAmount(),
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
        padding: const EdgeInsets.all(20.0),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(title,
            style: TextStyle(color: AppColors.kTextCardDetail, fontSize: 17)),
        SizedBox(
          height: 10,
        ),
        Text("€ ${_calculateThisMonthAmount()}",
            style: TextStyle(color: AppColors.kTextCardDetail, fontSize: 25))
      ],
    );
  }

  double _calculateThisMonthAmount() {
    return _paymentsThisMonth.map((payment) {
      return payment.subscription.price;
    }).fold(0.00, (current, next) {
      return current + next;
    });
  }

  void _fetchRenewalsThisMonth() async {
    final DateTime now = DateTime.now();
    final firstDateThisMonth = DatesHelper.firstDayOfMonth(DateTime.now());
    final DateTime lastDayMonth =
        DatesHelper.lastDayOfMonth(DateTime(now.year, now.month));

    final result = await _paymentRepository.fetchAllRenewalsByMonth(
        firstDateThisMonth, lastDayMonth);

    setState(() {
      _paymentsThisMonth = result;
    });
  }
}
