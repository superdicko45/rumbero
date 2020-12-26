import 'dart:ui';
import 'package:flutter/material.dart';

class Colors {

  const Colors();

  //static const Color loginGradientStart = const Color(0xFFfbab66);
  //static const Color loginGradientEnd = const Color(0xFFf7418c);

  static const Color loginGradientStart = const Color(0xff330867);
  static const Color loginGradientEnd = const Color(0xff30cfd0);

  static const Map<int, Color> colorCodes = {
    50: Color.fromRGBO(48, 207, 208, .1),
    100: Color.fromRGBO(48, 207, 208, .2),
    200: Color.fromRGBO(48, 207, 208, .3),
    300: Color.fromRGBO(48, 207, 208, .4),
    400: Color.fromRGBO(48, 207, 208, .5),
    500: Color.fromRGBO(48, 207, 208, .6),
    600: Color.fromRGBO(48, 207, 208, .7),
    700: Color.fromRGBO(48, 207, 208, .8),
    800: Color.fromRGBO(48, 207, 208, .9),
    900: Color.fromRGBO(48, 207, 208, 1),
  };

  static const MaterialColor colorM = const MaterialColor(0xff30cfd0, colorCodes);
  
  static const BoxDecoration myBoxDecButton = const  BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5.0)),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: loginGradientStart,
        offset: Offset(1.0, 6.0),
        blurRadius: 20.0,
      ),
      BoxShadow(
        color: loginGradientEnd,
        offset: Offset(1.0, 6.0),
        blurRadius: 20.0,
      ),
    ],
    gradient: LinearGradient(
      colors: [
        loginGradientEnd,
        loginGradientStart
      ],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp
    ),
  );

  static const BoxDecoration myBoxDecBackG = const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        loginGradientStart,
        loginGradientEnd
      ],
      begin: const FractionalOffset(0.0, 0.0),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp
    )
  );

  static const BoxDecoration myBoxDecNav = const  BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(100.0)),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0xFF5A5A5A),
        offset: Offset(1.0, 6.0),
        blurRadius: 20.0,
      ),
    ],
    gradient: LinearGradient(
      colors: [
        loginGradientEnd,
        loginGradientStart
      ],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp
    ),
  );


  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}