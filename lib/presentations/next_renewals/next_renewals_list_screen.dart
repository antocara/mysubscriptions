import 'package:flutter/material.dart';
import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/presentations/create_subscription/create_subscription_screen.dart';
import 'package:subscriptions/presentations/navigation_manager.dart';

class NextRenewalsListScreen extends StatefulWidget {
  @override
  _NextRenewalsListScreenState createState() => _NextRenewalsListScreenState();
}

class _NextRenewalsListScreenState extends State<NextRenewalsListScreen> {
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
        if (snapData.connectionState == ConnectionState.none &&
            snapData.hasData == null) {
          return Container();
        }
        return _buildList(snapData.data);
      },
    );
  }

  Widget _buildList(List<Renewal> data) {
    return ListView.builder(
        itemCount: data.length ?? 0,
        itemBuilder: (context, index) {
          Renewal renewal = data[index];
          return _buildRow(renewal);
        });
  }

  Card _buildRow(Renewal renewal) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album, size: 50),
            title: Text(renewal.subscription.name),
            subtitle: Text(renewal.subscription.description),
          ),
          Text(renewal.renewalAtPretty),
        ],
      ),
    );
  }

  Future<List<Renewal>> _fetchData() async {
    return _renewalRepository.fetchNextRenewalsForTwoMonths();
  }

  void _addClicked(BuildContext context) {
    NavigationManager.navigateToAddSubscription(context);
  }
}
