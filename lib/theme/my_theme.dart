
import 'package:flutter/material.dart';

class MyTheme{
  static themeData({required bool isDarkTheme,required BuildContext context}){
    return isDarkTheme?ThemeData(
      scaffoldBackgroundColor: Color(0xFF343541),
      primarySwatch: Colors.purple,
      primaryColor: Colors.deepPurple,
      dividerColor: Colors.white,
      disabledColor: Colors.grey,
      cardColor: Color(0xFF444654),
      canvasColor: Colors.black,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(color: Color(0xFF444654)),
      buttonTheme: Theme.of(context).buttonTheme.copyWith(colorScheme: ColorScheme.dark())
    ):ThemeData(
        scaffoldBackgroundColor: Colors.grey.shade300,
        primarySwatch: Colors.purple,
        primaryColor: Colors.deepPurple,
        dividerColor: Colors.black,
        disabledColor: Colors.grey,
        cardColor: Colors.white,
        canvasColor: Colors.grey[50],
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(color: Colors.white),
        buttonTheme: Theme.of(context).buttonTheme.copyWith(colorScheme: ColorScheme.light(),
    ));
  }
}