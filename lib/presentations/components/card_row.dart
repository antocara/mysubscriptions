import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/presentations/components/renewal_card.dart';

class CardRow extends StatelessWidget {
  CardRow({Key key, @required Renewal renewal, @required Function onTap})
      : _renewal = renewal,
        _onTap = onTap,
        super(key: key);

  final Function _onTap;
  final Renewal _renewal;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _onTap,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          RenewalCard(
            renewal: _renewal,
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
