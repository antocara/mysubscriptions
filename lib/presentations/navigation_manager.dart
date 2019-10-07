import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/presentations/create_subscription/create_subscription_screen.dart';
import 'package:subscriptions/presentations/renewal_detail/renewal_detail_screen.dart';

class NavigationManager {
  static void navigateToAddSubscription(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateSubscriptionScreen()),
    );
  }

  static void navigateToRenewalDetail(BuildContext context, Renewal renewal) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => RenewalDetail(
                renewal: renewal,
              )),
    );
  }

  static void popView(BuildContext context) {
    Navigator.of(context).pop();
  }
}
