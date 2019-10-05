import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/text_styles.dart'
    as AppTextStyles;

class DefaultAppBar extends StatefulWidget {
  const DefaultAppBar({Key key, this.title = "", this.icon, this.onButtonTap})
      : super(key: key);

  final String title;
  final Icon icon;
  final Function onButtonTap;

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    return _buildAppbar();
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: AppColors.defaultBackground,
      elevation: 0,
      title: _buildTitle(),
      actions: <Widget>[
        _buildIcon(),
      ],
    );
  }

  Text _buildTitle() {
    return Text(
      widget.title,
      style: AppTextStyles.titleAppBar,
    );
  }

  IconButton _buildIcon() {
    return IconButton(
      onPressed: widget.onButtonTap,
      icon: widget.icon,
      color: AppColors.iconsAppbar,
    );
  }
}
