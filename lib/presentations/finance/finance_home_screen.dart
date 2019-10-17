import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/finance/month_chart_screen.dart';
import 'package:subscriptions/presentations/finance/total_chart_screen.dart';
import 'package:subscriptions/presentations/finance/year_chart_screen.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;

class FinanceHomeScreen extends StatefulWidget {
  @override
  _FinanceHomeScreenState createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    new Tab(text: "This month"),
    new Tab(text: "Ths year"),
    new Tab(text: "Total")
  ];

  final List<Widget> tabsControllers = <Widget>[
    MonthChartScreen(),
    YearChartScreen(),
    TotalChartScreen()
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(
            iconTheme: IconThemeData(color: AppColors.kAppBarTitleDetail),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Finance",
                style: TextStyle(
                  color: AppColors.kAppBarTitleDetail,
                )),
            bottom: _buildBubbleTabBar()),
        body: _buildTabBarView());
  }

  Widget _buildBubbleTabBar() {
    return new TabBar(
      isScrollable: true,
      unselectedLabelColor: Colors.grey,
      labelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: new BubbleTabIndicator(
        indicatorHeight: 25.0,
        indicatorColor: Colors.blueAccent,
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
      ),
      tabs: tabs,
      controller: _tabController,
    );
  }

  Widget _buildTabBarView() {
    return new TabBarView(
      controller: _tabController,
      children: tabsControllers,
    );
  }
}
