main() {
//  group('Creation netx renewals from last payment', () {
//    DateTime _firstBill;
//    var _renewal = 1;
//    var _renewalPeriod;
//
//    Payment _payment;
//    Subscription _subscription;
//
//    ///setup
//    setUpAll(() {
//      final maxRenewalDay = DateTime(2040, 2, 1);
//      RenewalsService.maxRenewalDate = maxRenewalDay;
//    });

//    void _createSubscription() {
//      _subscription = Subscription(
//          firstBill: _firstBill,
//          renewal: _renewal,
//          renewalPeriod: _renewalPeriod);
//    }
//
//    void _createPayment() {
//      _payment = Payment(subscription: _subscription, insertAt: null);
//    }

//    ///create all renewals from last payment
//    test('create all renewals from las payment', () async {
//      final monthOffset = 2;
//      final now = DateTime.now();
//      _firstBill = DateTime(now.year, now.month - monthOffset, now.day);
//      _renewalPeriod = RenewalPeriodValues.month;
//      _createSubscription();
//      _createPayment();
//      final renewalsService = RenewalsService();
//
//      final result = await PaymentServices(null, null, renewalsService)
//          .calculateRenewalsDatesFrom(_payment);
//
//      expect(result.length, monthOffset + 1);
//    });
//  });
}
