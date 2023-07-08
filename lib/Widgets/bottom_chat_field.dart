import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/constants/constants.dart';
import 'package:my_virtual_assistant/provider/authentication_provider.dart';
import 'package:my_virtual_assistant/provider/chat_provider.dart';
import 'package:my_virtual_assistant/utility/utility.dart';
import 'package:provider/provider.dart';

import '../provider/my_theme_provider.dart';

class BottomChatField extends StatefulWidget {
  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController=TextEditingController();
    // TODO: implement initState
    super.initState();
  }

   @override
  void dispose() {
    // TODO: implement dispose
     textEditingController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<MyThemeProvider>(context).themeType;
    final color = isDarkTheme ? Colors.white : Colors.black;

    return Material(
      color: isDarkTheme?Constants.chatGPTDarkCardColor:Colors.white70,
      child: Row(
        children: [
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textEditingController,
                  style: TextStyle(color: color),
                  decoration: InputDecoration.collapsed(
                      hintText: "How Can I help you?",
                  hintStyle: TextStyle(color: color)),
                ),
              ),
          ),
          IconButton(onPressed: (){
            if(textEditingController.text.isEmpty){
              showSnackBar(context: context, content:'Please type a message');
              return;
            }
            context.read<chatProvider>().sendMessage
              (uid: context.read<AuthenticationProvider>().userModel.uid,
                message: textEditingController.text,
                modelId: '',
                onSuccess: (){
                print('success');
                },
                onCompleted: (){
                print('completed');
            });
          }, icon: Icon(Icons.send,color: color,))

        ],
      ),
    );
  }
}


