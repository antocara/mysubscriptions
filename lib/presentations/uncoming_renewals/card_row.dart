import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/presentations/widgets/renewal_card.dart';

class CardRow extends StatefulWidget {
  CardRow({Key key, @required Renewal renewal, @required Function onTap})
      : _renewal = renewal,
        _onTap = onTap,
        super(key: key);

  final Function _onTap;
  final Renewal _renewal;

  @override
  _CardRowState createState() => _CardRowState();
}

class _CardRowState extends State<CardRow> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget._onTap,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          RenewalCard(
            renewal: widget._renewal,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
