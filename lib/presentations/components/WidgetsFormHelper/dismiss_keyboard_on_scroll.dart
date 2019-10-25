import 'package:flutter/material.dart';

class DismissKeyboardOnScroll extends StatelessWidget {
  final Widget child;
  final Function onDismiss;

  const DismissKeyboardOnScroll({Key key, this.child, this.onDismiss})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollStartNotification>(
      onNotification: (x) {
        if (x.dragDetails == null) {
          return false;
        }

        FocusScope.of(context).unfocus();
        if (onDismiss != null) {
          onDismiss();
          return false;
        }
        return true;
      },
      child: child,
    );
  }
}
