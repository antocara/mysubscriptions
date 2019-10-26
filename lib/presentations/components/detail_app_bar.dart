import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/text_styles.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  DetailAppBar({Key key, Subscription subscription})
      : _subscription = subscription,
        preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final Subscription _subscription;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.kAppBarTitleDetail),
      backgroundColor: AppColors.kTransparent,
      elevation: 0,
      title: Text(_subscription.upperName, style: kTitleAppBar),
    );
  }
}
