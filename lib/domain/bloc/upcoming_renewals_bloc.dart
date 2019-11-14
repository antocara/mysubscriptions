import 'dart:async';
import 'package:subscriptions/data/di/renewal_inject.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/repositories/renewal_repository.dart';

class UpcomingRenewalsBloc {
  UpcomingRenewalsBloc() {
    _renewalRepository = RenewalInject.buildRenewalRepository();
  }

  RenewalRepository _renewalRepository;

  StreamController _streamController =
      StreamController<List<Renewal>>.broadcast();

  Stream<List<Renewal>> get upcomingRenewalsList => _streamController.stream;

  void fetchUpcomingRenewals() async {
    final renewals = await _renewalRepository.fetchNextRenewalsForTwoMonths();

    final renewalsSubsNotNull = renewals.where((renewal) {
      return renewal.subscription != null;
    }).toList();
    _streamController.add(renewalsSubsNotNull);
  }

  void disposed() {
    _streamController.close();
  }
}
