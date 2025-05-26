import 'package:flutter/material.dart'; 

import 'package:labart/utils/custom_themes/text_theme.dart';
import 'package:labart/utils/custom_themes/elevated_button_theme.dart';
import 'package:labart/utils/custom_themes/appbar_theme.dart';
import 'package:labart/utils/custom_themes/text_field_theme.dart';
import 'package:labart/utils/custom_themes/botton_sheet_theme.dart';
import 'package:labart/utils/custom_themes/checkbox_theme.dart';
import 'package:labart/utils/custom_themes/chip_theme.dart';
import 'package:labart/utils/custom_themes/outline_button_theme.dart';

class TAppTheme {
  TAppTheme._();


  static ThemeData lightTheme = ThemeData( 
    useMaterial3: true, 
    fontFamily: 'Poppins', 
    brightness: Brightness.light, 
    primaryColor: Colors.blue, 
    textTheme: TTextTheme.lightTextTheme, 
    chipTheme: TChipTheme.lightChipTheme, 
    scaffoldBackgroundColor: Colors.white, 
    appBarTheme: TAppBarTheme.lightAppBarTheme, 
    checkboxTheme: TCheckboxTheme.lightCheckboxTheme, 
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme, 
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme, 
    outlinedButtonTheme: ToutlinedButtonTheme.lightOutlinedButtonTheme, 
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme, 
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark, 
    primaryColor: Colors.blue,
    textTheme: TTextTheme.darkTextTheme, 
    chipTheme: TChipTheme.darkChipTheme, 
    scaffoldBackgroundColor: const Color.fromARGB(255, 19, 23, 24), //255, 28, 33, 39
    appBarTheme: TAppBarTheme.darkAppBarTheme, 
    checkboxTheme: TCheckboxTheme.darkCheckboxTheme, 
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme, 
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme, 
    outlinedButtonTheme: ToutlinedButtonTheme.darkOutlinedButtonTheme, 
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme, 
  );
}