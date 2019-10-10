import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/presentations/renewal_detail/subscription_detail_card.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/services/payments_services.dart';

class RenewalDetail extends StatefulWidget {
  RenewalDetail({Key key, @required Renewal renewal})
      : _renewal = renewal,
        super(key: key);

  final Renewal _renewal;

  @override
  _RenewalDetailState createState() => _RenewalDetailState();
}

class _RenewalDetailState extends State<RenewalDetail> {
  //PaymentServices _paymentServices;
  PaymentRepository _paymentRepository;

  @override
  void initState() {
    //_paymentServices = PaymentInject.buildPaymentServices();
    _paymentRepository = PaymentInject.buildPaymentRepository();
    _fetchPayments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: AppColors.kDefaultBackground,
        ),
        _buildBackDecorator(),
        _buildScaffold(),
      ],
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.kAppBarTitleDetail),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget._renewal.subscription.upperName,
            style: TextStyle(
              color: AppColors.kAppBarTitleDetail,
            )),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[_buildCard()],
    );
  }

  Widget _buildCard() {
    return SubscriptionDetailCard(
      renewal: widget._renewal,
    );
  }

  Widget _buildBackDecorator() {
    return ClipPath(
      clipper: DiagonalPathClipperOne(),
      child: Container(height: 240, color: widget._renewal.subscription.color),
    );
  }

  Future<List<Payment>> _fetchPayments() async {
    PaymentInject.buildPaymentServices().updatePaymentData();
    final a = await _paymentRepository
        .fetchPaymentsBySubscription(widget._renewal.subscription);
    print("");
  }
}
