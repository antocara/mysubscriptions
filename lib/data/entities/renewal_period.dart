import 'package:flutter/material.dart';

enum RenewalPeriodValues { day, week, month, year }

class RenewalPeriod {
  static const RENEWALS_CYCLE_VALUES = ['Day', 'Week', 'Month', 'Year'];

  static List<DropdownMenuItem> renewalCyclesValues() {
    return RENEWALS_CYCLE_VALUES.map<DropdownMenuItem<String>>((String value) {
      return _buildDropDownItem(value);
    }).toList();
  }

  static _buildDropDownItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }

  static enumOfString(String stringValue) {
    switch (stringValue) {
      case 'Day':
        return RenewalPeriodValues.day;
      case 'Week':
        return RenewalPeriodValues.week;
      case 'Month':
        return RenewalPeriodValues.month;
      case 'Year':
        return RenewalPeriodValues.year;
    }
  }

  static stringValueFromEnum(RenewalPeriodValues enumValue) {
    switch (enumValue) {
      case RenewalPeriodValues.day:
        return 'Day';
      case RenewalPeriodValues.week:
        return 'Week';
      case RenewalPeriodValues.month:
        return 'Month';
      case RenewalPeriodValues.year:
        return 'Year';
    }
  }
}
