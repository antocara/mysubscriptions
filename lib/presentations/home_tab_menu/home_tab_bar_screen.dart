import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/finance/finance_home_screen.dart';
import 'package:subscriptions/presentations/settings/settings_screen.dart';
import 'package:subscriptions/presentations/uncoming_renewals/upcoming_renewals_list_screen.dart';

import '../styles/colors.dart' as AppColors;

class HomeTabMenuScreen extends StatefulWidget {
  @override
  _HomeTabMenuScreenState createState() => _HomeTabMenuScreenState();
}

class _HomeTabMenuScreenState extends State<HomeTabMenuScreen> {
  int _currentTabIndex = 0;

  List<Widget> tabsScreen = [
    UpcomingRenewalsListScreen(),
    FinanceHomeScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kCreateSubscriptionBack,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _onItemTabTaped(index),
        currentIndex: _currentTabIndex,
        items: [
          _buildBottomItem("Upcoming", Icons.subscriptions),
          _buildBottomItem("Finance", Icons.monetization_on),
          _buildBottomItem("Settings", Icons.settings_applications),
        ],
      ),
      body: tabsScreen[_currentTabIndex],
    );
  }

  BottomNavigationBarItem _buildBottomItem(String title, IconData iconData) {
    return BottomNavigationBarItem(
      title: Text(title),
      icon: Icon(iconData),
    );
  }

  void _onItemTabTaped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }
}
