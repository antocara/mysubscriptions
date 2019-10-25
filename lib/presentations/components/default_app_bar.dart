import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/text_styles.dart'
    as AppTextStyles;

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  DefaultAppBar({Key key, this.title = "", this.icon, this.onButtonTap})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  final String title;
  final Icon icon;
  final Function onButtonTap;

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState();

  @override
  final Size preferredSize;
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    return _buildAppbar();
  }

  AppBar _buildAppbar() {
    return AppBar(
      iconTheme: IconThemeData(color: AppColors.kAppBarTitle),
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: _buildTitle(),
      actions: <Widget>[_buildIcon()],
    );
  }

  Text _buildTitle() {
    return Text(
      widget.title,
      style: AppTextStyles.kTitleAppBar,
    );
  }

  Widget _buildIcon() {
    if (widget.icon != null) {
      return IconButton(
        onPressed: widget.onButtonTap,
        icon: widget.icon,
        color: AppColors.kAppBarIcons,
      );
    } else {
      return SizedBox();
    }
  }
}
