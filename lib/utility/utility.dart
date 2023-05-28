import 'package:flutter/material.dart';

void showSnackBar({required BuildContext context,required String content}){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content:Text(content,textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10,color: Colors.white),))
  );
}