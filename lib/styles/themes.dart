import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';


ThemeData darkTheme=ThemeData(
    fontFamily: 'Jannah',
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    textTheme: TextTheme(
        bodyText1:const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
        bodyText2: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w200,
          fontSize: 15,
        ),
        caption: TextStyle(
            color: Colors.white.withOpacity(0.5)
        )
    ),
    scaffoldBackgroundColor: HexColor('333739'),
    appBarTheme: AppBarTheme(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        elevation: 0,
        backgroundColor: HexColor('333739'),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
          statusBarColor: HexColor('333739'),
        ),
        titleTextStyle: const TextStyle(
            fontFamily: 'Jannah',
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        )
    ),
    cardColor: HexColor('333739'),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: HexColor('333739'),
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey[500],
    )
);

ThemeData lightTheme=ThemeData(
    fontFamily: 'Jannah',
    scaffoldBackgroundColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black87,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyText1:TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w600,
        fontSize: 24,
      ),
      bodyText2: TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.w200,
        fontSize: 15,
      ),
    ),
    appBarTheme: const AppBarTheme(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0,
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.white,
        ),
        titleTextStyle: TextStyle(
            fontFamily: 'Jannah',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        )
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: Colors.grey[500],
    )
);