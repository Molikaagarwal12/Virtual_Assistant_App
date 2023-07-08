



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/constants/constants.dart';
import 'package:uuid/uuid.dart';

class chatProvider extends ChangeNotifier{
  bool _isTyping=false;
  bool _isText=true;
  bool get isTyping=> _isTyping;
  bool get isText=> _isText;

  final FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  Stream<QuerySnapshot<Object?>> getChatScreen({required String uid}){
    final Stream<QuerySnapshot> chatStream =
    firebaseFirestore.collection(Constants.chat).doc(uid).
    collection(Constants.chatGPTChats).snapshots();

    return chatStream;
  }
  Future<void> sendMessage({
  required String uid,
    required String message,
    required String modelId,
    required Function onSuccess,
    required Function onCompleted
}) async{
    try{
      _isTyping=true;
      notifyListeners();

      await sendMessageToFireStore(uid: uid, message: message);
      _isTyping=false;
      onSuccess();
    }catch(error){
      _isTyping=false;
      notifyListeners();
      print(error);
    }finally{
      _isTyping=false;
      notifyListeners();
      onCompleted();
    }
  }

  Future<void> sendMessageToFireStore({
  required String uid,
    required String message,
})async{
    String chatId= Uuid().v4();
    await firebaseFirestore.collection(Constants.chat).
    doc(uid).collection('chatGptChats').doc(chatId).set({
      Constants.senderId:uid,
      Constants.chatId:chatId,
      Constants.message:message,
      Constants.MessageTime:FieldValue.serverTimestamp(),
      Constants.isText:isText
    });
  }}