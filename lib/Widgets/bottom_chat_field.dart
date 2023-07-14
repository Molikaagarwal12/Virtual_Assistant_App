// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/constants/constants.dart';
import 'package:my_virtual_assistant/provider/authentication_provider.dart';
import 'package:my_virtual_assistant/provider/chat_provider.dart';
import 'package:my_virtual_assistant/utility/utility.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../provider/my_theme_provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({super.key});

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  late TextEditingController textEditingController;
  late FocusNode focusNode;
  SpeechToText speechToText=SpeechToText();
  String chatGptModel='gpt-3.5-turbo';
  bool showSendButton=false;
  String _lastWords='';
  

  @override
  void initState() {
    textEditingController=TextEditingController();
    focusNode=FocusNode();
    initializeSpeechToText();
    
    super.initState();
  }

   @override
  void dispose() {
    
     textEditingController.dispose();
    super.dispose();
  }
    void initializeSpeechToText() async{
      await speechToText.initialize();
    }
  
  void _startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
    print('words : $_lastWords');
    if(speechToText.isNotListening) {
      _stopListening();

      context.read<chatProvider>().sendMessage(
        uid: context.read<AuthenticationProvider>().userModel.uid,
        message: _lastWords,
        modelId: chatGptModel,
        onSuccess: (){
          textEditingController.text = '';
          focusNode.unfocus();
          print('success');
        },
        onCompleted: (){
          print('completed');
        },
      );

    }
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
                  focusNode: focusNode,
                  controller: textEditingController,
                  style: TextStyle(color: color),
                  decoration: InputDecoration.collapsed(
                      hintText: "How Can I help you?",
                  hintStyle: TextStyle(color: color)),

                  onChanged: (value){
                    if(value.isNotEmpty){
                     setState(() {
                        showSendButton=true;
                      });
                    }else{
                      setState(() {
                        showSendButton=false;
                      });
                    }
                  },
                  onSubmitted: (value){
                    if(textEditingController.text.isEmpty){
              showSnackBar(context: context, content:'Please type a message');
              return;
            }
             if(context.read<chatProvider>().isTyping){
              showSnackBar(context: context, content:'Please wait for response');
              return;
            }

            context.read<chatProvider>().sendMessage
              (uid: context.read<AuthenticationProvider>().userModel.uid,
                message: textEditingController.text,
                modelId: chatGptModel,
                onSuccess: (){
                  textEditingController.clear();
                  focusNode.unfocus();
                print('success');
                },
                onCompleted: (){
                print('completed');
            });
                  },
                ),
              ),
          ),
          IconButton(onPressed: (){
            if(showSendButton) {
              if(textEditingController.text.isEmpty){
              showSnackBar(context: context, content:'Please type a message');
              return;
            }
             if(context.read<chatProvider>().isTyping){
              showSnackBar(context: context, content:'Please wait for response');
              return;
            }

            context.read<chatProvider>().sendMessage
              (uid: context.read<AuthenticationProvider>().userModel.uid,
                message: textEditingController.text,
                modelId: chatGptModel,
                onSuccess: (){
                  textEditingController.clear();
                  focusNode.unfocus();
                print('success');
                },
                onCompleted: (){
                print('completed');
            });
            }else{
              _startListening();
            }
          }, icon: Icon(showSendButton?Icons.send:Icons.mic),color: color,)

        ],
      ),
    );
  }
}


