import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/domain/di/bloc_inject.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/components/detail_app_bar.dart';
import 'package:subscriptions/presentations/components/subscription_card_amount.dart';
import 'package:subscriptions/presentations/components/subscription_detail_card.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/text_styles.dart';

class SubscriptionDetail extends StatefulWidget {
  SubscriptionDetail({Key key, @required Renewal renewal})
      : _renewal = renewal,
        super(key: key);

  final Renewal _renewal;

  @override
  _SubscriptionDetailState createState() => _SubscriptionDetailState();
}

class _SubscriptionDetailState extends State<SubscriptionDetail> {
  final _bloc = BlocInject.buildSubscriptionDetailBloc();

  @override
  void initState() {
    _bloc.fetchUpcomingRenewals(subscription: widget._renewal.subscription);
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

  Widget _buildBackDecorator() {
    return ClipPath(
      clipper: DiagonalPathClipperOne(),
      child: Container(height: 240, color: widget._renewal.subscription.color),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kTransparent,
      appBar: DetailAppBar(subscription: widget._renewal.subscription),
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
        _buildPaymentListTitle(context),
        _buildSeparator(),
        Expanded(
          child: _buildPaymentList(),
        )
      ],
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

  Widget _buildPaymentListTitle(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, top: 5, right: 3, bottom: 3),
        child: Text(
          AppLocalizations.of(context).translate("payments"),
          style: TextStyle(fontSize: 20, color: AppColors.kWhiteColor),
        ),
      ),
    );
  }

  Widget _buildPaymentList() {
    return StreamBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none ||
            !projectSnap.hasData) {
          return CircularProgressIndicator();
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(color: AppColors.kListDividerColor);
            },
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              Payment payment = projectSnap.data[index];
              return _buildPaymentRow(payment);
            },
          );
        }
      },
      stream: _bloc.paymentsBySubscriptions,
    );
  }

  Widget _buildPaymentRow(Payment payment) {
    final date = DatesHelper.toStringFromDate(payment.renewalAt);
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 5, bottom: 5, right: 25),
        child: Column(
          children: <Widget>[
            Text("${payment.subscription.priceAtStringFormat}",
                style: kTitleDetailPaymentRow),
            Text(date, style: kAmountDetailPaymentRow),
          ],
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return SizedBox(
      height: 10,
    );
  }
}
