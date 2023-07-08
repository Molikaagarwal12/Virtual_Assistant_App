import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/Screens/AI_Chat_Screen.dart';
import 'package:my_virtual_assistant/Screens/Post_Screen.dart';
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
   List<Widget> tabs=[AiChatScreen(),PostScreen(),ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    final themeStatus=Provider.of<MyThemeProvider>(context);
    Color color=themeStatus.themeType?Colors.white:Colors.black;
    return Scaffold(
      body: tabs[Sindex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: color,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
        currentIndex: Sindex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline),label: 'A.I Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.post_add_outlined),label: 'Posts'),
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
