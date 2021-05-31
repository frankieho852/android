

import 'package:flutter/material.dart';
import 'package:online_shopping_4521/theme/colors.dart';

ThemeData appTheme() {
  return ThemeData(
    fontFamily: 'Asap',
    // highlightColor: Colors.white,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0.8)),
    textTheme: TextTheme(
      headline2: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Color(kBlack),
      ),
      headline3: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Color(kBlack),
      ),
      headline4: TextStyle(
        fontSize: 24,
        color: Color(kBlack),
        fontWeight: FontWeight.w400,
      ),
      headline5: TextStyle(
        fontSize: 18,
        color: Color(kBlack),
        fontWeight: FontWeight.w400,
      ),
      headline6: TextStyle(
        fontSize: 16,
        // height: 1.2,
        color: Color(kBlack),
      ),
      // subtitle1: TextStyle(
      //   fontSize: 16,
      //   color: Color(kBlack),
      // ),
      // subtitle2: TextStyle(
      //   fontSize: 12,
      //   color: Color(kBlack),
      // ),
      bodyText1: TextStyle(
        fontSize: 14,
        color: Color(kBlack),
      ),
      bodyText2: TextStyle(
        fontSize: 12,
        color: Color(kBlack),
      ),
      caption: TextStyle(
        fontSize: 16,
        color: Color(kErrorRed),
        fontWeight: FontWeight.w500,
        // fontFamily: 'FutuBk',
      ),
    ),
  );
}
