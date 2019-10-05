import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/create_subscription/create_subscription_screen.dart';
import 'package:subscriptions/presentations/home_tab_menu/home_tab_bar_screen.dart';
import 'package:subscriptions/presentations/uncoming_renewals/upcoming_renewals_list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeTabMenuScreen(),
    );
  }
}
