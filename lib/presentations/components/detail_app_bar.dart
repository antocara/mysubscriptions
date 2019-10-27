import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/subscription.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/text_styles.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  DetailAppBar({Key key, @required String title})
      : _title = title,
        preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  String _title;
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.kAppBarTitleDetail),
      backgroundColor: AppColors.kTransparent,
      elevation: 0,
      title: Text(_title, style: kTitleAppBar),
    );
  }
}
