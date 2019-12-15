import 'package:flutter/material.dart';

class HomeBottomNavigationBarItem {
  static navigationBarItem({String title, IconData icons}) {
    return BottomNavigationBarItem(
      title: Text(title),
      icon: Icon(icons),
    );
  }
}
