import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/create_subscription/create_subscription_screen.dart';

class NavigationManager {
  static void navigateToAddSubscription(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateSubscriptionScreen()),
    );
  }
}
