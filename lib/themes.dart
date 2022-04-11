import 'package:flutter/cupertino.dart';

class MainTheme {
  static Color backgroundBackdropColor = Color(0xff101010);
  static Color backgroundGameplayBoxColor = Color(0xff202020);
  static Color lightTextColor = Color(0xffFADFAD);
  static Color darkTextColor = Color(0xff7e4e2c);
  static Color alertDialogBorderColor = Color(0xff9D5C0D);
  static List<Color> mainButtonGradientColors = [
    Color(0xffF2A65A),
    Color(0xff772F1A),
  ];

  static LinearGradient mainButtonGradient = LinearGradient(
    colors: mainButtonGradientColors,
    tileMode: TileMode.mirror,
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
