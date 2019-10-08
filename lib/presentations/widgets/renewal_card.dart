import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/renewal.dart';
import 'package:subscriptions/presentations/styles/dimens.dart' as AppDimens;

class RenewalCard extends StatefulWidget {
  RenewalCard({Key key, @required Renewal renewal})
      : _renewal = renewal,
        super(key: key);

  final Renewal _renewal;

  @override
  _RenewalCardState createState() => _RenewalCardState();
}

class _RenewalCardState extends State<RenewalCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard)),
      margin: EdgeInsets.symmetric(
          vertical: 0, horizontal: AppDimens.defaultHorizontalMargin),
      elevation: 10,
      color: widget._renewal.subscription.color ?? Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget._renewal.subscription.name ?? "",
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Text(
                  widget._renewal.subscription.priceAtStringFormat,
                  style: TextStyle(fontSize: 35, color: Colors.white),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget._renewal.subscription.description ?? "",
                style: TextStyle(color: Colors.white, fontSize: 14),
                maxLines: 2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Payment day:",
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(widget._renewal.renewalAtPretty ?? "",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  CircleAvatar(
                    foregroundColor:
                        widget._renewal.subscription.color ?? Colors.white,
                    backgroundColor: Colors.white,
                    child: Text(widget._renewal.subscription.nameChars),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//  String _extractChars() {
//    final name = widget._renewal.subscription.name ?? "";
//    if (name != null && name.length >= 2) {
//      return name.substring(0, 2).toUpperCase();
//    }
//    return "";
//  }
}
