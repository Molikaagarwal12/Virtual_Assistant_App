import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class MyThemeProvider extends ChangeNotifier{
  bool _isDarkTheme=false;

  bool get themeType=>_isDarkTheme;

  set setTheme(bool value){
    _isDarkTheme=value;
    saveThemeToSharePreferences(value: value);
    notifyListeners();
  }
  void saveThemeToSharePreferences({required bool value}) async{
    final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences.setBool(Constants.themeStatus, value);
  }

  getThemeStatus() async{
    final SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    _isDarkTheme=   sharedPreferences.getBool(Constants.themeStatus)??false;
    notifyListeners();
  }
}