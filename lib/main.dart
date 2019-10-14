import 'package:flutter/material.dart';
import 'package:subscriptions/data/di/payment_inject.dart';
import 'package:subscriptions/helpers/colors_helper.dart';
import 'package:subscriptions/presentations/create_subscription/create_subscription_screen.dart';
import 'package:subscriptions/presentations/home_tab_menu/home_tab_bar_screen.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/uncoming_renewals/upcoming_renewals_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _initializeServices();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: AppColors.kPrimaryColor,
        primaryColorDark: AppColors.kPrimaryColorDark,
      ),
      home: HomeTabMenuScreen(),
    );
  }

  void _initializeServices() {
    PaymentInject.buildPaymentServices().updatePaymentData();
  }
}
