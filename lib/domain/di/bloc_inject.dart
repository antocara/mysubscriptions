import 'package:subscriptions/domain/bloc/detail_renewal_bloc.dart';
import 'package:subscriptions/domain/bloc/upcoming_renewals_bloc.dart';

class BlocInject {
  static UpcomingRenewalsBloc buildUpcomingRenewalsBloc() {
    return UpcomingRenewalsBloc();
  }

  static DetailRenewalBloc buildSubscriptionDetailBloc() {
    return DetailRenewalBloc();
  }
}
