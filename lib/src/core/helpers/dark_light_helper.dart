import 'package:flutter/material.dart';
import 'package:firebasedemo/src/configs/app_colors.dart';

final kDarkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'SFProText',
  primaryColor: AppColor.kDarkPrimaryColor,
  canvasColor: AppColor.kDarkPrimaryColor,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: AppColor.primarySwatchColor,
    brightness: Brightness.dark,
  ).copyWith(background: Colors.white),
  iconTheme: ThemeData.dark().iconTheme.copyWith(
        color: AppColor.kLightSecondaryColor,
      ),
  textTheme: ThemeData.dark().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: AppColor.kLightSecondaryColor,
        displayColor: AppColor.kLightSecondaryColor,
      ),
);

final kLightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'SFProText',
  primaryColor: AppColor.kLightPrimaryColor,
  canvasColor: AppColor.kLightPrimaryColor,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: AppColor.primarySwatchColor,
    brightness: Brightness.light,
  ).copyWith(background: Colors.white),
  iconTheme: ThemeData.light().iconTheme.copyWith(
        color: AppColor.kDarkSecondaryColor,
      ),
  textTheme: ThemeData.light().textTheme.apply(
        fontFamily: 'SFProText',
        bodyColor: AppColor.kDarkSecondaryColor,
        displayColor: AppColor.kDarkSecondaryColor,
      ),
);
