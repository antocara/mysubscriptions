import 'package:flutter/material.dart';
import 'package:subscriptions/presentations/styles/colors.dart' as AppColors;
import 'package:subscriptions/presentations/styles/dimens.dart';

// upcoming renewals
const kTitleAppBar =
    TextStyle(fontSize: kAppBarTitle, color: AppColors.kAppBarTitle);
const kTitleHeaderRow = TextStyle(fontSize: 20, color: AppColors.kAppBarTitle);
const kSubTitleHeaderRow =
    TextStyle(fontSize: 30, color: AppColors.kAppBarTitle);

//susbcription card
const kCardTitle = TextStyle(fontSize: 28, color: AppColors.kWhiteColor);
const kCardPrice = TextStyle(fontSize: 35, color: AppColors.kWhiteColor);
final kCardDescription =
    TextStyle(color: AppColors.kCardDescriptionColor, fontSize: 14);
final kCardPaymentDayTitle =
    TextStyle(color: AppColors.kCardPaymentDayTitleColor, fontSize: 13);
const kCardPaymentDay = TextStyle(color: AppColors.kWhiteColor, fontSize: 20);
