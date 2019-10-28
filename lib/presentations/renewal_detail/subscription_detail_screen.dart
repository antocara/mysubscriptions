import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/data/entities/payment.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/domain/di/bloc_inject.dart';
import 'package:subscriptions/helpers/dates_helper.dart';
import 'package:subscriptions/presentations/components/app_bar_detail.dart';
import 'package:subscriptions/presentations/components/subscription_detail_card.dart';
import 'package:subscriptions/presentations/components/subscription_detail_card_amount.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/components.dart';
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

  List<Payment> _listPayments = [];

  @override
  void initState() {
    _bloc.fetchUpcomingRenewals(subscription: widget._renewal.subscription);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.disposed();
    super.dispose();
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
      appBar: AppBarDetail(title: widget._renewal.subscription.upperName),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _buildCard(),
              _buildSeparator(),
              _buildAmountCard(),
              _buildSeparator(),
              _buildPaymentListTitle(context),
              _buildSeparator(),
              _buildPaymentList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return SubscriptionDetailCard(
      renewal: widget._renewal,
    );
  }

  Widget _buildAmountCard() {
    return StreamBuilder(
      builder: (context, projectSnap) {
        if (!projectSnap.hasData && _listPayments.length == 0) {
          return Container();
        } else {
          if (projectSnap.hasData) {
            _listPayments = projectSnap.data;
          }
          return SubscriptionDetailCardAmount(
            currentYearAmount: _calculateCurrentYearAmount(),
            totalAmount: _calculateTotalAmount(),
          );
        }
      },
      stream: _bloc.paymentsBySubscriptions,
    );
  }

  Widget _buildPaymentListTitle(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 25, top: 5, right: 3, bottom: 3),
        child: Text(
          AppLocalizations.of(context).translate("payments_made"),
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
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return kListDividerWidget;
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

  String _calculateCurrentYearAmount() {
    if (_listPayments == null) return "";
    final double result = _listPayments
        .where((payment) {
          return DatesHelper.belongThisYear(payment.renewalAt);
        })
        .toList()
        .fold(0, (initial, next) {
          return initial + next.subscription.price;
        });

    return result.toStringAsFixed(2);
  }

  String _calculateTotalAmount() {
    if (_listPayments == null) return "";
    final double result = _listPayments.fold(0, (initial, next) {
      return initial + next.subscription.price;
    });

    return result.toStringAsFixed(2);
  }
}
