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
final kCardDescriptionTextStyle =
    TextStyle(color: AppColors.kCardDescriptionColor, fontSize: 14);
final kCardPaymentDayTitle =
    TextStyle(color: AppColors.kCardPaymentDayTitleColor, fontSize: 13);
const kCardPaymentDay = TextStyle(color: AppColors.kWhiteColor, fontSize: 20);

//subscription detail
const kTitleDetailPaymentRow =
    TextStyle(fontSize: 23, color: AppColors.kWhiteColor);
const kAmountDetailPaymentRow =
    TextStyle(fontSize: 15, color: AppColors.kWhiteColor);
final kCardDetailAmountTitle =
    TextStyle(color: AppColors.kTextCardDetail.withOpacity(.50), fontSize: 17);
final kCardDetailAmount =
    TextStyle(color: AppColors.kTextCardDetail, fontSize: 20);

//settings
const kTitleSettings = TextStyle(fontSize: 18, color: AppColors.kWhiteColor);

//form
const kInputFormContent =
    TextStyle(fontSize: 15, color: AppColors.kPrimaryColorDark);
const kInputFormHint =
    TextStyle(fontSize: 15, color: AppColors.kLightPrimaryColor);
