import 'package:flocateapp/theme/appbar_theme.dart';
import 'package:flocateapp/theme/bottom_sheet_theme.dart';
import 'package:flocateapp/theme/checkbox_theme.dart';
import 'package:flocateapp/theme/chip_theme.dart';
import 'package:flocateapp/theme/constants/colors.dart';
import 'package:flocateapp/theme/elevated_button_theme.dart';
import 'package:flocateapp/theme/outlined_button_theme.dart';
import 'package:flocateapp/theme/text_field_theme.dart';
import 'package:flocateapp/theme/text_theme.dart';
import 'package:flutter/material.dart';

class KAppTheme {
  KAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: KColors.grey,
    brightness: Brightness.light,
    primaryColor: KColors.primary,
    textTheme: KTextTheme.lightTextTheme,
    chipTheme: KChipTheme.lightChipTheme,
    scaffoldBackgroundColor: KColors.white,
    appBarTheme: KAppBarTheme.lightAppBarTheme,
    checkboxTheme: KCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: KBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: KElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: KOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: KTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    disabledColor: KColors.grey,
    brightness: Brightness.dark,
    primaryColor: KColors.primary,
    textTheme: KTextTheme.darkTextTheme,
    chipTheme: KChipTheme.darkChipTheme,
    scaffoldBackgroundColor: KColors.black,
    appBarTheme: KAppBarTheme.darkAppBarTheme,
    checkboxTheme: KCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: KBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: KElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: KOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: KTextFormFieldTheme.darkInputDecorationTheme,
  );
}
