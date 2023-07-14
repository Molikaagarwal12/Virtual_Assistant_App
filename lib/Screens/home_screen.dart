// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/Screens/AI_Chat_Screen.dart';

import 'package:my_virtual_assistant/Screens/Profile_Screen.dart';
import 'package:my_virtual_assistant/provider/my_theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int Sindex=0;
   // ignore: prefer_const_constructors
   List<Widget> tabs=[AiChatScreen(),ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    final themeStatus=Provider.of<MyThemeProvider>(context);
    Color color=themeStatus.themeType?Colors.white:Colors.black;
    return Scaffold(
      body: tabs[Sindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: color,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        currentIndex: Sindex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline),label: 'A.I Chat'),
          
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_outlined),label: 'Profile'),
        ],
        onTap: (index){
          setState(() {
            Sindex=index;
          });
        },
      ),
    );
  }
}
