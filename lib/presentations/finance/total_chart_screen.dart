import 'package:flutter/material.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/finance/chart_widgets/bar_chart_yearly.dart';
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;

class TotalChartScreen extends StatefulWidget {
  @override
  _TotalChartScreenState createState() => _TotalChartScreenState();
}

class _TotalChartScreenState extends State<TotalChartScreen> {
  PaymentRepository _paymentRepository;

  @override
  void initState() {
    _paymentRepository = PaymentInject.buildPaymentRepository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildYearlyCard();
  }

  Widget _buildYearlyCard() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none ||
            !projectSnap.hasData) {
          return Container();
        } else {
          return Container(
            height: 350,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimens.borderRadiusCard)),
              margin: EdgeInsets.symmetric(
                  vertical: 0, horizontal: AppDimens.kDefaultHorizontalMargin),
              elevation: 10,
              child: BarChartYearly(
                paymentList: projectSnap.data,
              ),
            ),
          );
        }
      },
      future: _fetchRenewalsUntilToday(),
    );
  }

  Future<List<Payment>> _fetchRenewalsUntilToday() async {
    final DateTime now = DateTime.now();
    final firstDateYear = DatesHelper.firstDayOfYear(DateTime.now());

    final result =
        await _paymentRepository.fetchAllRenewalsByMonth(firstDateYear, now);
    return result;
  }
}
