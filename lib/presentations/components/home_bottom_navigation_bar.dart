import 'package:flutter/material.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/presentations/components/home_bottom_navigation_bar_item.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;

class HomeBottomNavigationBar extends StatefulWidget {
  HomeBottomNavigationBar({Key key, Function onTabSelected})
      : _onTabSelected = onTabSelected,
        super(key: key);

  final Function _onTabSelected;

  @override
  _HomeBottomNavigationBarState createState() =>
      _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return _buildNavigationBar(context);
  }

  BottomNavigationBar _buildNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.kNavigationBar,
      onTap: (index) => _onItemTabTaped(index),
      currentIndex: _currentTabIndex,
      items: _buildNavigationItems(context),
      unselectedItemColor: AppColors.kLightPrimaryColor,
      selectedItemColor: AppColors.kPrimaryColorDark,
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems(BuildContext context) {
    return [
      HomeBottomNavigationBarItem.navigationBarItem(
          title: AppLocalizations.of(context).translate('upcoming'),
          icons: Icons.subscriptions),
      HomeBottomNavigationBarItem.navigationBarItem(
          title: AppLocalizations.of(context).translate('finance'),
          icons: Icons.monetization_on),
      HomeBottomNavigationBarItem.navigationBarItem(
          title: AppLocalizations.of(context).translate('settings'),
          icons: Icons.settings_applications)
    ];
  }

  void _onItemTabTaped(int index) {
    widget._onTabSelected(index);
    setState(() {
      _currentTabIndex = index;
    });
  }
}
