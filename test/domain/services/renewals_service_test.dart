import 'package:flutter_test/flutter_test.dart';
import 'package:subscriptions/data/entities/renewal_period.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/domain/services/renewals_service.dart';

main() {
  // group('Creation of renewlas', () {
  //   late DateTime _firstBill;
  //   var _renewal = 1;
  //   var _renewalPeriod;
  //
  //   late Subscription _subscription;
  //
  //   ///setup
  //   setUpAll(() {
  //     final maxRenewalDay = DateTime(2040, 2, 1);
  //     RenewalsService.maxRenewalDate = maxRenewalDay;
  //   });
  //
  //   void _createSubscription() {
  //     _subscription = Subscription(
  //         firstBill: _firstBill,
  //         renewal: _renewal!,
  //         renewalPeriod: _renewalPeriod!);
  //   }
  //
  //   ///create all renewals for a subscription, the total to create is three
  //   test('create all renewals for a subscription, the total to create is three',
  //       () async {
  //     _firstBill = DateTime(2039, 12, 1);
  //     _renewalPeriod = RenewalPeriodValues.month;
  //     _createSubscription();
  //
  //     final result =
  //         await RenewalsService().createRenewalsForSubscription(_subscription);
  //
  //     expect(result.length, 3);
  //   });
  //
  //   ///create all renewals for a subscription, the total to create is three
  //   test('create all renewals for a subscription, the total to create is three',
  //       () async {
  //     _firstBill = DateTime(2040, 1, 29);
  //     _renewalPeriod = RenewalPeriodValues.day;
  //     _createSubscription();
  //
  //     final result =
  //         await RenewalsService().createRenewalsForSubscription(_subscription);
  //
  //     expect(result.length, 4);
  //   });
  //
  //   ///check the renewal date created at is correct
  //   test(
  //       'create all renewals for a subscription, check the renewaldate at is correct',
  //       () async {
  //     _firstBill = DateTime(2039, 12, 1);
  //     _renewalPeriod = RenewalPeriodValues.month;
  //     _createSubscription();
  //     final result =
  //         await RenewalsService().createRenewalsForSubscription(_subscription);
  //
  //     expect(result[0].renewalAt, _firstBill);
  //     expect(result.last.renewalAt, RenewalsService.maxRenewalDate);
  //   });
  // });
  //
  // group('Creation of renewlas between days', () {
  //   late DateTime _firstBill;
  //   var _renewal = 1;
  //   var _renewalPeriod;
  //
  //   late Subscription _subscription;
  //
  //   ///setup
  //   setUpAll(() {
  //     final maxRenewalDay = DateTime(2040, 2, 1);
  //     RenewalsService.maxRenewalDate = maxRenewalDay;
  //   });
  //
  //   void _createSubscription() {
  //     _subscription = Subscription(
  //         firstBill: _firstBill,
  //         renewal: _renewal,
  //         renewalPeriod: _renewalPeriod);
  //   }
  //
  //   test('create all renewals for a subscription, the total to create is three',
  //       () async {
  //     _firstBill = DateTime(2039, 12, 1);
  //     _renewalPeriod = RenewalPeriodValues.month;
  //     _createSubscription();
  //
  //     final startDate = DateTime(2040, 1, 1);
  //     final endDate = DateTime(2040, 2, 1);
  //
  //     final result = await RenewalsService()
  //         .createRenewalsForSubscriptionBetween(
  //             subscription: _subscription,
  //             startDate: startDate,
  //             endDate: endDate);
  //
  //     expect(result.length, 2);
  //     expect(result.length, isNot(3));
  //   });
  //
  // });
}
