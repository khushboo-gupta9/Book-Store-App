import 'package:flutter/material.dart';

class TColor {
static Color get primary => const Color.fromARGB(255, 69, 222, 203);
  static Color get primaryLight => Color.fromARGB(255, 122, 170, 170);
  static Color get text => const Color(0xff212121);
  static Color get subTitle => const Color(0xff212121).withOpacity(0.4);

  static Color get color1 => const Color(0xff1C4A7E);
  static Color get color2 => const Color(0xffC65135);

  static Color get dColor => const Color(0xffF3F3F3);

  static Color get textbox => const Color(0xffEFEFEF).withOpacity(0.6);

  static List<Color> get button => const [
        Color.fromARGB(255, 21, 137, 155),
        Color.fromARGB(255, 14, 165, 184),
      ];

  static List<Color> get searchBGColor => const [
        Color(0xffB7143C),
        Color(0xffE6A500),
        Color(0xffEF4C45),
        Color(0xffF46217),
        Color(0xff09ADE2),
        Color(0xffD36A43),
      ];
}
