import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/create_subscription/create_subscription_screen.dart';
import 'package:subscriptions/presentations/next_renewals/next_renewals_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NextRenewalsListScreen(),
    );
  }
}
