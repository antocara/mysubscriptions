import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/components/home_bottom_navigation_bar.dart';
import 'package:subscriptions/presentations/finance/finance_home_screen.dart';
import 'package:subscriptions/presentations/settings/settings_screen.dart';
import 'package:subscriptions/presentations/upcoming_renewals/upcoming_renewals_list_screen.dart';

import '../styles/colors.dart' as AppColors;

class HomeTabMenuScreen extends StatefulWidget {
  @override
  _HomeTabMenuScreenState createState() => _HomeTabMenuScreenState();
}

class _HomeTabMenuScreenState extends State<HomeTabMenuScreen> {
  final List<Widget> _tabsScreen = [
    UpcomingRenewalsListScreen(),
    FinanceHomeScreen(),
    SettingsScreen(),
  ];

  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kCreateSubscriptionBack,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: _activeController(),
    );
  }

  HomeBottomNavigationBar _buildBottomNavigationBar() {
    return HomeBottomNavigationBar(
      onTabSelected: (indexTabSelected) {
        setState(() {
          _currentTabIndex = indexTabSelected;
        });
      },
    );
  }

  Widget _activeController() {
    return _tabsScreen[_currentTabIndex];
  }
}
