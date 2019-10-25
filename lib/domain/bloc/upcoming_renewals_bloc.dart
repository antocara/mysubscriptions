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
    _streamController.add(renewals);
  }

  void disposed() {
    _streamController.close();
  }
}
