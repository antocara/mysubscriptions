import 'package:flutter/material.dart';
import 'package:subscriptions/data/di/renewal_inject.dart';

class NextRenewalsListScreen extends StatefulWidget {
  @override
  _NextRenewalsListScreenState createState() => _NextRenewalsListScreenState();
}

class _NextRenewalsListScreenState extends State<NextRenewalsListScreen> {
  final _renewalRepository = RenewalInject.buildRenewalRepository();

  @override
  Widget build(BuildContext context) {
    _fetchData();

    return Container();
  }

  void _fetchData() async {
    final result = await _renewalRepository.fetchNextRenewalsForTwoMonths();
    print("");
  }
}
