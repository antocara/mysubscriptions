import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/text_styles.dart';

class AppBarDetail extends StatelessWidget implements PreferredSizeWidget {
  AppBarDetail(
      {Key key,
      @required String title,
      @required Function onDeletePressed,
      PreferredSizeWidget bottomWidget})
      : _title = title,
        _bottomWidget = bottomWidget,
        _onDeletedPressed = onDeletePressed,
        preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String _title;
  final PreferredSizeWidget _bottomWidget;
  @override
  final Size preferredSize;
  final Function _onDeletedPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.kAppBarTitleDetail),
      actions: <Widget>[
        IconButton(onPressed: _onDeletedPressed, icon: Icon(Icons.delete)),
      ],
      backgroundColor: AppColors.kTransparent,
      elevation: 0,
      title: Text(_title, style: kTitleAppBar),
      bottom: _bottomWidget,
    );
  }
}
