
// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_virtual_assistant/Widgets/chat_list.dart';
import 'package:my_virtual_assistant/provider/chat_provider.dart';
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
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Nexus-Virtual Assistant",style: TextStyle(color:color),),
        ),
        actions: [
          IconButton(onPressed: (){
            context.read<chatProvider>().setIsText(textMode: true);
          }, icon: Icon(Icons.chat, 
          color: context.read<chatProvider>().isText?color:Colors.grey,)),

           IconButton(onPressed: (){
            context.read<chatProvider>().setIsText(textMode: false);
          }, icon: Icon(Icons.image, 
          color: !context.read<chatProvider>().isText?color:Colors.grey,))
        ],
      ),
      body:SafeArea(
        child: Column(
          children: [
            const Expanded(child:ChatList() ),

            if(context.watch<chatProvider>().isTyping) ...[
              SpinKitDoubleBounce(
                color:color,
                size: 18,
              )
            ],

            SizedBox(height: 10,),

            BottomChatField()

          ],
        ),
      )
    );
  }
}
