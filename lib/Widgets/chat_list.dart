import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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


  @override
  Widget build(BuildContext context) {
    final uid=context.read<AuthenticationProvider>().userModel.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: context.read<chatProvider>().getChatScreen(uid:uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: Colors.orangeAccent,),
          );
        }
        if(snapshot.data!.docs.isEmpty){
          return Center(
            child: Text(
                'Chat is Empty',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5
            ),),

          );
        }
        final messageSnapShot=snapshot.data!.docs;
        return ListView.builder(
          itemCount: messageSnapShot.length,
            itemBuilder: (context,index){
          return ListTile(
            title: Text(messageSnapShot[index][Constants.message]),
            );

        });


        // return ListView(
        //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //     Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        //     return ListTile(
        //       title: Text(data['name']),
        //       subtitle: Text(data['phone']),
        //     );
        //   }).toList(),
        // );
      },
    );
  }
}
