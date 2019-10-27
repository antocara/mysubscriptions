import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/app_localizations.dart';
import 'package:subscriptions/presentations/components/app_bar_detail.dart';
import 'package:subscriptions/presentations/components/background_circles.dart';
import 'package:subscriptions/presentations/finance/finance_month_screen.dart';
import 'package:subscriptions/presentations/finance/total_chart_screen.dart';
import 'package:subscriptions/presentations/finance/year_chart_screen.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;

class FinanceHomeScreen extends StatefulWidget {
  @override
  _FinanceHomeScreenState createState() => _FinanceHomeScreenState();
}

class _FinanceHomeScreenState extends State<FinanceHomeScreen>
    with SingleTickerProviderStateMixin {
  final List<Widget> tabsControllers = <Widget>[
    FinanceMonthScreen(),
    YearChartScreen(),
    TotalChartScreen()
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  List<Tab> _createTabs(BuildContext context) {
    return <Tab>[
      new Tab(
          text: AppLocalizations.of(context).translate("finance_this_month")),
      new Tab(
          text: AppLocalizations.of(context).translate("finance_this_year")),
      new Tab(text: AppLocalizations.of(context).translate("finance_total"))
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        BackgroundCircles(),
        _buildScaffold(context),
      ],
    );
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDefaultBackground,
      appBar: AppBarDetail(
        title: "",
        bottomWidget: _buildBubbleTabBar(context),
      ),
      body: _buildTabBarView(),
    );
  }

  Widget _buildBubbleTabBar(BuildContext context) {
    return new TabBar(
      isScrollable: true,
      unselectedLabelColor: AppColors.kLightPrimaryColor,
      labelColor: AppColors.kWhiteColor,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: new BubbleTabIndicator(
        indicatorHeight: 35.0,
        indicatorColor: AppColors.kPrimaryColorDark,
        tabBarIndicatorSize: TabBarIndicatorSize.tab,
      ),
      tabs: _createTabs(context),
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
