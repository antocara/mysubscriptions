import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/renewal.dart';

class RenewalDetail extends StatefulWidget {
  RenewalDetail({Key key, @required this.renewal}) : super(key: key);

  final Renewal renewal;

  @override
  _RenewalDetailState createState() => _RenewalDetailState();
}

class _RenewalDetailState extends State<RenewalDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.renewal.subscription.name),
      ),
    );
  }
}
