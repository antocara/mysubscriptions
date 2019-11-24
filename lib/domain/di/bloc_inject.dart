import 'package:subscriptions/domain/bloc/add_subscription_bloc.dart';
import 'package:subscriptions/domain/bloc/detail_renewal_bloc.dart';
import 'package:subscriptions/domain/bloc/finance_bloc.dart';
import 'package:subscriptions/domain/bloc/upcoming_renewals_bloc.dart';

class BlocInject {
  static UpcomingRenewalsBloc buildUpcomingRenewalsBloc() {
    return UpcomingRenewalsBloc();
  }

  static DetailRenewalBloc buildSubscriptionDetailBloc() {
    return DetailRenewalBloc();
  }

  static FinanceBloc buildFinanceBloc() {
    return FinanceBloc();
  }

  static AddSubscriptionBloc buildAddSubscriptionBloc(){
    return AddSubscriptionBloc();
  }
}
