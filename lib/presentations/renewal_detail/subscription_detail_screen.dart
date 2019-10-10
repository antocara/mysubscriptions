import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/data/repositories/payment_repository.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/renewal_detail/subscription_card_amount.dart';
import 'package:subscriptions/presentations/renewal_detail/subscription_detail_card.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;

class RenewalDetail extends StatefulWidget {
  RenewalDetail({Key key, @required Renewal renewal})
      : _renewal = renewal,
        super(key: key);

  final Renewal _renewal;

  @override
  _RenewalDetailState createState() => _RenewalDetailState();
}

class _RenewalDetailState extends State<RenewalDetail> {
  PaymentRepository _paymentRepository;

  @override
  void initState() {
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
        _buildScaffold(context),
      ],
    );
  }

  Widget _buildScaffold(BuildContext context) {
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
    return Column(
      children: <Widget>[
        _buildCard(),
        _buildSeparator(),
        _buildAmountCard(),
        _buildSeparator(),
        _buildPaymentListTitle(),
        _buildSeparator(),
        Expanded(
          child: _buildPaymentList(),
        )
      ],
    );
  }

  Widget _buildPaymentList() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none &&
            projectSnap.hasData == null) {
          return CircularProgressIndicator();
        }

        return ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.black.withOpacity(0.3),
            );
          },
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            Payment payment = projectSnap.data[index];
            return _buildPaymentRow(payment);
          },
        );
      },
      future: _fetchPayments(),
    );
  }

  Widget _buildCard() {
    return SubscriptionDetailCard(
      renewal: widget._renewal,
    );
  }

  Widget _buildAmountCard() {
    return SubscriptionCardAmount(
      renewal: widget._renewal,
    );
  }

  Widget _buildPaymentListTitle() {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppDimens.defaultHorizontalMargin, top: 5, right: 3, bottom: 3),
      child: Text(
        "Payments",
        style: TextStyle(fontSize: 20, color: AppColors.kTextCardDetail),
      ),
    );
  }

  Widget _buildPaymentRow(Payment payment) {
    final date = DatesHelper.toStringFromDate(payment.renewalAt);
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 5),
      child: Text(
        date,
        style: TextStyle(
            fontSize: 20, color: AppColors.kTextCardDetail.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildSeparator() {
    return SizedBox(
      height: 10,
    );
  }

  Widget _buildBackDecorator() {
    return ClipPath(
      clipper: DiagonalPathClipperOne(),
      child: Container(height: 240, color: widget._renewal.subscription.color),
    );
  }

  Future<List<Payment>> _fetchPayments() async {
    final paymentList = await _paymentRepository
        .fetchPaymentsBySubscription(widget._renewal.subscription);
    return paymentList;
  }
}
