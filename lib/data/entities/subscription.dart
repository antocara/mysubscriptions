import 'package:flutter/material.dart';
import 'package:subscriptions/data/entities/renewal_period.dart';
import 'package:subscriptions/helpers/colors_helper.dart';
import 'package:subscriptions/helpers/dates_helper.dart';

class Subscription {
  Subscription(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.firstBill,
      this.color,
      this.renewal,
      this.renewalPeriod});

  int id;
  String name;
  String description;
  double price;
  DateTime firstBill;
  Color color;
  int renewal;
  RenewalPeriodValues renewalPeriod;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'first_bill': firstBillSince1970,
      'color': colorValue,
      'renewal': renewal,
      'renewal_period': renewalPeriodStringValue
    };
  }

  static Subscription fromMap(Map<String, dynamic> map) {
    return Subscription(
        id: map['id'],
        name: map['name'],
        description: map['description'],
        price: map['price'],
        firstBill: DatesHelper.toDateFromEpoch(map['first_bill']),
        color: ColorHelper.toColorFromValue(map['color']),
        renewal: map['renewal'],
        renewalPeriod: RenewalPeriod.enumOfString(map['renewal_period']));
  }

  // Conversión de valores apra guardarlos corectamente en
  // sqlite según los tipos que maneja

  int get firstBillSince1970 {
    return firstBill.millisecondsSinceEpoch ?? 0.00;
  }

  int get colorValue {
    if (color != null) {
      return ColorHelper.toValueFromColor(color);
    } else {
      return 0000;
    }
  }

  String get renewalPeriodStringValue {
    if (renewalPeriod != null) {
      return RenewalPeriod.stringValueFromEnum(renewalPeriod);
    } else {
      return "";
    }
  }

  String get priceAtStringFormat {
    if (price != null) {
      return "€ ${price.toString()}";
    } else {
      return "€ 0.00";
    }
  }

  String get nameChars {
    if (name != null && name.length >= 2) {
      return name.substring(0, 2).toUpperCase();
    }
    return "";
  }

  String get upperName {
    if (name != null) {
      return name[0].toUpperCase() + name.substring(1);
    } else {
      return "";
    }
  }

  String get firstPaymentAtPretty {
    return DatesHelper.toStringFromDate(firstBill);
  }

  @override
  bool operator ==(o) => o is Subscription && name == o.name;
  int get hashCode => name.hashCode + colorValue.hashCode;
}
