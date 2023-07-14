import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_virtual_assistant/Widgets/chat_widget.dart';
import 'package:my_virtual_assistant/constants/constants.dart';
import 'package:my_virtual_assistant/provider/authentication_provider.dart';
import 'package:my_virtual_assistant/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({Key? key}) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController messageScrollController=ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    messageScrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final uid = context.read<AuthenticationProvider>().userModel.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: context.read<chatProvider>().getChatStream(uid: uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orangeAccent,
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'Chat is empty!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          );
        }

       SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        messageScrollController.jumpTo(messageScrollController.position.maxScrollExtent);
       });
        final messageSnapShot = snapshot.data!.docs;
        print(messageSnapShot);

        return ListView.builder(
          itemCount: messageSnapShot.length,
          controller: messageScrollController,
          itemBuilder: (context, index) {

             return ChatWidget(
              message: messageSnapShot[index][Constants.message], 
              senderId: messageSnapShot[index][Constants.senderId], 
              isText:  messageSnapShot[index][Constants.isText],);
            
            // ListTile(
            //   title: Text(messageContent),
            // );
          },
        );
      },
    );
  }
}

