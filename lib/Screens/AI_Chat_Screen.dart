

import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/Widgets/chat_list.dart';
import 'package:provider/provider.dart';

import '../Widgets/bottom_chat_field.dart';
import '../provider/my_theme_provider.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({Key? key}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  @override
  Widget build(BuildContext context) {
    final themeStatus=Provider.of<MyThemeProvider>(context);
    Color color=themeStatus.themeType?Colors.white:Colors.black;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Nexus-Virtual Assistant",style: TextStyle(color:color),),
      ),
      body:SafeArea(
        child: Column(
          children: [
            Expanded(child:ChatList() ),
            SizedBox(height: 10,),
            BottomChatField()

          ],
        ),
      )
    );
  }
}
