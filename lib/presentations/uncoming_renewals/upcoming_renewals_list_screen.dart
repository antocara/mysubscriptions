import 'package:flutter/material.dart';
import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/presentations/navigation_manager.dart';
import 'package:subscriptions/presentations/uncoming_renewals/card_row.dart';
import 'package:subscriptions/presentations/uncoming_renewals/header_row.dart';
import 'package:subscriptions/presentations/widgets/default_app_bar.dart';

class UpcomingRenewalsListScreen extends StatefulWidget {
  @override
  _UpcomingRenewalsListScreenState createState() =>
      _UpcomingRenewalsListScreenState();
}

class _UpcomingRenewalsListScreenState
    extends State<UpcomingRenewalsListScreen> {
  final _renewalRepository = RenewalInject.buildRenewalRepository();

  @override
  Widget build(BuildContext context) {
    _fetchData();

    return Column(
      children: <Widget>[
        DefaultAppBar(
          title: "Upcoming Renewals",
          icon: Icon(Icons.add),
          onButtonTap: () {
            _addClicked(context);
          },
        ),
        Expanded(
          child: _buildBody(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return FutureBuilder(
      future: _fetchData(),
      builder: (context, snapData) {
        if (snapData.hasError || snapData.hasData == null) {
          return Container();
        } else {
          return _buildList(snapData.data);
        }
      },
    );
  }

  Widget _buildList(List<Renewal> data) {
    if (data == null) return Container();
    final itemCount = (data.length + 2);
    return ListView.builder(
        itemCount: itemCount ?? 0,
        itemBuilder: (context, index) {
          if (index == 0) {
            final amount = _calculateAmountByMonth(data, DateTime.now().month);
            return HeaderRow(title: "This month", amount: amount);
          } else if (_isRenewalOfCurrentMonth(index, data)) {
            index -= 1;
            return _bindCardRow(data[index]);
          } else if (_isRenewalOfNextMonth(index, data)) {
            final amount =
                _calculateAmountByMonth(data, DateTime.now().month + 1);
            return HeaderRow(
              title: "Next month",
              amount: amount,
            );
          } else {
            index -= 2;
            return _bindCardRow(data[index]);
          }
        });
  }

  CardRow _bindCardRow(Renewal renewal) {
    return CardRow(
      renewal: renewal,
      onTap: () => _navigateToDetail(context, renewal),
    );
  }

  Future<List<Renewal>> _fetchData() async {
    return _renewalRepository.fetchNextRenewalsForTwoMonths();
  }

  double _calculateAmountByMonth(List<Renewal> data, int month) {
    return data.where((renewal) {
      return renewal.renewalAt.month == month;
    }).fold(0, (initialValue, renewal) {
      return initialValue + renewal.subscription.price;
    });
  }

  void _addClicked(BuildContext context) {
    NavigationManager.navigateToAddSubscription(context);
  }

  void _navigateToDetail(BuildContext context, Renewal renewal) {
    NavigationManager.navigateToRenewalDetail(context, renewal);
  }

  //Utils
  int countRenewalThisMonth(List<Renewal> data) {
    return data
        .where((renewal) {
          return _isAtThisMonth(renewal);
        })
        .toList()
        .length;
  }

  bool _isAtThisMonth(Renewal renewal) {
    final currentMonth = DateTime.now().month;
    return currentMonth == renewal.renewalAt.month;
  }

  bool _isRenewalOfCurrentMonth(int index, List<Renewal> data) {
    return (index > 0 && index < countRenewalThisMonth(data) + 1);
  }

  bool _isRenewalOfNextMonth(int index, List<Renewal> data) {
    return index == countRenewalThisMonth(data) + 1;
  }
}
