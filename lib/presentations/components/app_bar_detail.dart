import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/text_styles.dart';

class AppBarDetail extends StatelessWidget implements PreferredSizeWidget {
  AppBarDetail(
      {Key key, @required String title, PreferredSizeWidget bottomWidget})
      : _title = title,
        _bottomWidget = bottomWidget,
        preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String _title;
  final PreferredSizeWidget _bottomWidget;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.kAppBarTitleDetail),
      backgroundColor: AppColors.kTransparent,
      elevation: 0,
      title: Text(_title, style: kTitleAppBar),
      bottom: _bottomWidget,
    );
  }
}
