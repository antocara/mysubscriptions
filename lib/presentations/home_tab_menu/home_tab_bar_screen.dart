import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/uncoming_renewals/upcoming_renewals_list_screen.dart';

class HomeTabMenuScreen extends StatefulWidget {
  @override
  _HomeTabMenuScreenState createState() => _HomeTabMenuScreenState();
}

class _HomeTabMenuScreenState extends State<HomeTabMenuScreen> {
  int _currentTabIndex = 0;

  List<Widget> tabsScreen = [
    UpcomingRenewalsListScreen(),
    UpcomingRenewalsListScreen(),
    UpcomingRenewalsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => _onItemTabTaped(index),
        currentIndex: _currentTabIndex,
        items: [
          BottomNavigationBarItem(
            title: Text("Upcoming"),
            icon: Icon(Icons.subscriptions),
          ),
          BottomNavigationBarItem(
            title: Text("Finance"),
            icon: Icon(Icons.monetization_on),
          ),
          BottomNavigationBarItem(
            title: Text("Settings"),
            icon: Icon(Icons.settings_applications),
          )
        ],
      ),
      body: tabsScreen[_currentTabIndex],
    );
  }

  void _onItemTabTaped(int index) {
    setState(() {
      _currentTabIndex = index;
    });
  }
}
