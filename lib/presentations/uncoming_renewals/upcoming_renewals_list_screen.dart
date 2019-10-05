import 'package:flutter/material.dart';
import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/presentations/navigation_manager.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Text("Uncoming Renewals"),
        actions: <Widget>[
          IconButton(
            onPressed: () => _addClicked(context),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: _buildBody(),
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
    final itemCount = (data.length + 2);
    return ListView.builder(
        itemCount: itemCount ?? 0,
        itemBuilder: (context, index) {
          print("itemcount $itemCount");
          print("$index");
          if (index == 0) {
            return _buildHeaderRow("This month");
          } else if (index > 0 && index < countRenewalThisMonth(data) + 1) {
            index -= 1;
            Renewal renewal = data[index];
            return _buildRow(context, renewal);
          } else if (index == countRenewalThisMonth(data) + 1) {
            return _buildHeaderRow("Next month");
          } else {
            index -= 2;
            Renewal renewal = data[index];
            return _buildRow(context, renewal);
          }
        });
  }

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

  Widget _buildRow(BuildContext context, Renewal renewal) {
    return InkWell(
      onTap: () => _navigateToDetail(context, renewal),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Card(
            color: renewal.subscription.color,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(
                      Icons.live_tv,
                      size: 50,
                      color: Colors.white,
                    ),
                    title: Text(
                      renewal.subscription.name,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(renewal.subscription.description,
                        style: TextStyle(color: Colors.white)),
                  ),
                  Text(renewal.renewalAtPretty,
                      style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderRow(String headerTitle) {
    return Container(
      height: 60,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            headerTitle,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }

  Future<List<Renewal>> _fetchData() async {
    return _renewalRepository.fetchNextRenewalsForTwoMonths();
  }

  void _addClicked(BuildContext context) {
    NavigationManager.navigateToAddSubscription(context);
  }

  void _navigateToDetail(BuildContext context, Renewal renewal) {
    NavigationManager.navigateToRenewalDetail(context, renewal);
  }
}
