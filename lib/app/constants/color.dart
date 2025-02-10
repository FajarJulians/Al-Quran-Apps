import 'package:flutter/material.dart';

const appPurple = Color(0xff431AA1);
const appPurpleLight = Color(0xffB79FD2);
const appPurpleDark = Color(0xff1E0771);
const appWhite = Color(0xffFAF9FC);
const appOrange = Color(0xffE6704A);
// const app1 = Color(0xff);
// const app2 = Color(0xff);
// const app3 = Color(0xff);

ThemeData themeLight = ThemeData(
  brightness: Brightness.light,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: appPurpleDark,
  ),
  primaryColor: appPurple,
  scaffoldBackgroundColor: appWhite,
  appBarTheme: AppBarTheme(
    backgroundColor: appPurple,
    elevation: 4,
    iconTheme: IconThemeData(color: appWhite),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: appPurpleDark),
    bodyMedium: TextStyle(color: appPurpleDark),
    bodySmall: TextStyle(color: appPurpleDark),
  ),
  listTileTheme: ListTileThemeData(textColor: appPurpleDark),
  tabBarTheme: TabBarTheme(
    labelColor: appPurpleDark,
    unselectedLabelColor: Colors.grey,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: appPurpleDark,
        ),
      ),
    ),
  ),
);

ThemeData themeDark = ThemeData(
  brightness: Brightness.dark,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: appWhite,
  ),
  primaryColor: appPurple,
  scaffoldBackgroundColor: appPurpleDark,
  appBarTheme: AppBarTheme(
    backgroundColor: appPurpleDark,
    elevation: 0,
    iconTheme: IconThemeData(color: appWhite),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: appWhite),
    bodyMedium: TextStyle(color: appWhite),
    bodySmall: TextStyle(color: appWhite),
  ),
  listTileTheme: ListTileThemeData(textColor: appWhite),
  tabBarTheme: TabBarTheme(
    labelColor: appWhite,
    unselectedLabelColor: Colors.grey,
    indicator: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: appWhite,
        ),
      ),
    ),
  ),
);
