import 'package:flutter/material.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/domain/di/bloc_inject.dart';
import 'package:subscriptions/domain/services/admob_service.dart';
import 'package:subscriptions/helpers/finances_helper.dart';
import 'package:subscriptions/helpers/renewals_helper.dart';
import 'package:subscriptions/presentations/components/app_bar_default.dart';
import 'package:subscriptions/presentations/components/card_row.dart';
import 'package:subscriptions/presentations/components/header_row.dart';
import 'package:subscriptions/presentations/navigation_manager.dart';

class UpcomingRenewalsListScreen extends StatefulWidget {
  @override
  _UpcomingRenewalsListScreenState createState() {
    return _UpcomingRenewalsListScreenState();
  }
}

class _UpcomingRenewalsListScreenState extends State<UpcomingRenewalsListScreen> {
  final upcomingRenewalsBloc = BlocInject.buildUpcomingRenewalsBloc();
  AdmobService _admobService;

  @override
  void initState() {
    upcomingRenewalsBloc.fetchUpcomingRenewals();
    _admobService = AdmobService();
    _admobService.displayInterstitialLaunch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildAppBar(context),
        _buildBody(),
      ],
    );
  }

  AppBarDefault _buildAppBar(BuildContext context) {
    return AppBarDefault(
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
          return _factoryRows(context, index, data);
        });
  }

  Widget _factoryRows(BuildContext context, int index, List<Renewal> data) {
    if (index == 0) {
      return _buildHeaderRowCurrentMonth(context, data);
    } else if (RenewalsHelper.isRenewalOfCurrentMonth(index, data)) {
      index -= 1;
      return _bindCardRow(context, data[index]);
    } else if (RenewalsHelper.isRenewalOfNextMonth(index, data)) {
      return _buildHeaderRowNextMonth(context, data);
    } else {
      index -= 2;
      return _bindCardRow(context, data[index]);
    }
  }

  HeaderRow _buildHeaderRowCurrentMonth(BuildContext context, List<Renewal> data) {
    final amount = FinancesHelper.calculateAmountByMonth(data, DateTime.now().month);
    return _buildHeaderRow(AppLocalizations.of(context).translate("current_month"), amount);
  }

  HeaderRow _buildHeaderRowNextMonth(BuildContext context, List<Renewal> data) {
    final amount = FinancesHelper.calculateAmountByMonth(data, DateTime.now().month + 1);
    return _buildHeaderRow(AppLocalizations.of(context).translate("next_month"), amount);
  }

  HeaderRow _buildHeaderRow(String title, double amount) {
    return HeaderRow(title: title, amount: amount);
  }

  CardRow _bindCardRow(BuildContext context, Renewal renewal) {
    return CardRow(renewal: renewal, onTap: () => _navigateToDetail(context, renewal));
  }

  void _createSubscriptionClicked(BuildContext context) async {
    final result = await NavigationManager.navigateToAddSubscription(context);
    if (result != null && result) {
      upcomingRenewalsBloc.fetchUpcomingRenewals();
    }
  }

  void _navigateToDetail(BuildContext context, Renewal renewal) async {
    final result = await NavigationManager.navigateToRenewalDetail(context, renewal);
    if (result != null && result) {
      upcomingRenewalsBloc.fetchUpcomingRenewals();
    }
  }

  @override
  void dispose() {
    upcomingRenewalsBloc.disposed();
    _admobService.disposedInterstitialLaunch();
    super.dispose();
  }
}
