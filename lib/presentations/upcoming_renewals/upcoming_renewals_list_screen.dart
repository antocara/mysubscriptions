import 'package:flutter/material.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/repositories/renewal_repository.dart';
import 'package:subscriptions/domain/di/upcoming_renewals_bloc_inject.dart';
import 'package:subscriptions/domain/upcoming_renewals_bloc.dart';
import 'package:subscriptions/helpers/finances_helper.dart';
import 'package:subscriptions/helpers/renewals_helper.dart';
import 'package:subscriptions/presentations/components/card_row.dart';
import 'package:subscriptions/presentations/components/default_app_bar.dart';
import 'package:subscriptions/presentations/components/header_row.dart';
import 'package:subscriptions/presentations/navigation_manager.dart';

class UpcomingRenewalsListScreen extends StatefulWidget {
  @override
  _UpcomingRenewalsListScreenState createState() =>
      _UpcomingRenewalsListScreenState();
}

class _UpcomingRenewalsListScreenState
    extends State<UpcomingRenewalsListScreen> {
  final upcomingRenewalsBloc = BlocInject.buildUpcomingRenewalsBloc();

  @override
  void initState() {
    upcomingRenewalsBloc.fetchUpcomingRenewals();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildAppBar(),
        _buildBody(),
      ],
    );
  }

  DefaultAppBar _buildAppBar() {
    return DefaultAppBar(
      title: AppLocalizations.of(context).translate("upcoming_renewal"),
      icon: Icon(Icons.add),
      onButtonTap: () {
        _createSubscriptionClicked(context);
      },
    );
  }

  Widget _buildBody() {
    return Expanded(
      child: StreamBuilder(
        stream: upcomingRenewalsBloc.upcomingRenewalsList,
        builder: (context, snapData) {
          if (snapData.hasError || snapData.hasData == null) {
            return Container(); //todo
          } else {
            return _buildList(snapData.data);
          }
        },
      ),
    );
  }

  Widget _buildList(List<Renewal> data) {
    if (data == null) return Container(); //todo
    final itemCount = (data.length + 2);
    return ListView.builder(
        itemCount: itemCount ?? 0,
        itemBuilder: (context, index) {
          return _factoryRows(index, data);
        });
  }

  Widget _factoryRows(int index, List<Renewal> data) {
    if (index == 0) {
      return _buildHeaderRowCurrentMonth(data);
    } else if (RenewalsHelper.isRenewalOfCurrentMonth(index, data)) {
      index -= 1;
      return _bindCardRow(data[index]);
    } else if (RenewalsHelper.isRenewalOfNextMonth(index, data)) {
      return _buildHeaderRowNextMonth(data);
    } else {
      index -= 2;
      return _bindCardRow(data[index]);
    }
  }

  HeaderRow _buildHeaderRowCurrentMonth(List<Renewal> data) {
    final amount =
        FinancesHelper.calculateAmountByMonth(data, DateTime.now().month);
    return _buildHeaderRow(
        AppLocalizations.of(context).translate("current_month"), amount);
  }

  HeaderRow _buildHeaderRowNextMonth(List<Renewal> data) {
    final amount =
        FinancesHelper.calculateAmountByMonth(data, DateTime.now().month + 1);
    return _buildHeaderRow(
        AppLocalizations.of(context).translate("next_month"), amount);
  }

  HeaderRow _buildHeaderRow(String title, double amount) {
    return HeaderRow(title: title, amount: amount);
  }

  CardRow _bindCardRow(Renewal renewal) {
    return CardRow(
        renewal: renewal, onTap: () => _navigateToDetail(context, renewal));
  }

  void _createSubscriptionClicked(BuildContext context) {
    NavigationManager.navigateToAddSubscription(context);
  }

  void _navigateToDetail(BuildContext context, Renewal renewal) {
    NavigationManager.navigateToRenewalDetail(context, renewal);
  }

  @override
  void deactivate() {
    upcomingRenewalsBloc.disposed();
    super.deactivate();
  }
}
