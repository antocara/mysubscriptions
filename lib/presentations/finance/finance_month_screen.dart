import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/domain/di/bloc_inject.dart';
import 'package:subscriptions/presentations/components/finance_amount.dart';
import 'package:subscriptions/presentations/components/finance_row.dart';
import 'package:subscriptions/presentations/finance/chart_widgets/semi_circle_chart.dart';

class FinanceMonthScreen extends StatefulWidget {
  @override
  _FinanceMonthScreenState createState() => _FinanceMonthScreenState();
}

class _FinanceMonthScreenState extends State<FinanceMonthScreen> {
  final _bloc = BlocInject.buildFinanceBloc();

  @override
  void initState() {
    _bloc.fetchRenewalsThisMonth();
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
            return _buildScrollWidgets(projectSnap.data);
          }
        },
        stream: _bloc.paymentsThisMonth,
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
              FinanceAmount(
                payments: data,
              ),
              _buildSubscriptionList(data)
            ],
          ),
        ),
      ],
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
        final rowData = FinanceRowData(
            title: subscription.name,
            color: subscription.color,
            amount: subscription.price);
        return FinanceRow(data: rowData);
      },
    );
  }

  @override
  void dispose() {
    _bloc.disposed();
    super.dispose();
  }
}
