// ignore_for_file: camel_case_types, avoid_print, unused_local_variable

import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:my_virtual_assistant/constants/constants.dart';
import 'package:my_virtual_assistant/services/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class chatProvider extends ChangeNotifier {
  bool _isTyping = false;
  bool _isText = true;

  TextToSpeech textToSpeech=TextToSpeech();
  bool _isListening = false;
  bool _shouldSpeek = false;
    bool get isTyping => _isTyping;
  bool get isText => _isText;
  bool get isListening => _isListening;
  bool get shouldSpeek => _shouldSpeek;


  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  AudioPlayer audioPlayer = AudioPlayer();

  void setIsText({required bool textMode}) {
    _isText = textMode;
    notifyListeners();
  }
  void setShouldSpeek({required bool speak}) {
   _shouldSpeek = speak;
    notifyListeners();
  }

  void setIsListening({required bool listening}) {
   _isListening = listening;
    notifyListeners();
  }

  Stream<QuerySnapshot<Object?>> getChatStream({required String uid}) {
    final Stream<QuerySnapshot> chatStream = firebaseFirestore
        .collection(Constants.chat)
        .doc(uid)
        .collection('chatGptChats')
        .orderBy(Constants.MessageTime)
        .snapshots();

    return chatStream;
  }

  Future<void> sendMessage(
      {required String uid,
      required String message,
      required String modelId,
      required Function onSuccess,
      required Function onCompleted}) async {
    try {
      _isTyping = true;
      notifyListeners();

      await sendMessageToFireStore(uid: uid, message: message);
      await sendMessageToChatGpt(
          uid: uid, message: message, isText: isText, modelId: modelId);
      _isTyping = false;
      onSuccess();
    } catch (error) {
      _isTyping = false;
      notifyListeners();
      print(error);
    } finally {
      _isTyping = false;
      notifyListeners();
      onCompleted();
    }
  }

  Future<void> sendMessageToFireStore({
    required String uid,
    required String message,
  }) async {
    String chatId = const Uuid().v4();
    await firebaseFirestore
        .collection(Constants.chat)
        .doc(uid)
        .collection('chatGptChats')
        .doc(chatId)
        .set({
      Constants.senderId: uid,
      Constants.chatId: chatId,
      Constants.message: message,
      Constants.MessageTime: FieldValue.serverTimestamp(),
      Constants.isText: isText
    });
  }

  Future<void> sendMessageToChatGpt({
    required String uid,
    required String message,
    required bool isText,
    required String modelId,
  }) async {
    String chatId = const Uuid().v4();
    String answer = await ApiService.SendMessageToChatGpt(
        message: message, modelId: modelId, isText: isText);
       
    if (isText) {
      if(shouldSpeek){
       var convertedAudio= await ApiService.fetchAudioBytes(
        text: answer, 
        voiceId:'21m00Tcm4TlvDq8ikWAM', 
        );
        await playAudioToText(audioBytes: convertedAudio);
      }
      
      await firebaseFirestore
          .collection(Constants.chat)
          .doc(uid)
          .collection('chatGptChats')
          .doc(chatId)
          .set({
        Constants.senderId: 'assistant',
        Constants.chatId: chatId,
        Constants.message: answer,
        Constants.MessageTime: FieldValue.serverTimestamp(),
        Constants.isText: isText
      });
    } else {
      String imageUrl = await saveImageFileToStorage(url: answer);
      await firebaseFirestore
          .collection(Constants.chat)
          .doc(uid)
          .collection('chatGptChats')
          .doc(chatId)
          .set({
        Constants.senderId: 'assistant',
        Constants.chatId: chatId,
        Constants.message: imageUrl,
        Constants.MessageTime: FieldValue.serverTimestamp(),
        Constants.isText: isText
      });
    }
  }

  Future<String> saveImageFileToStorage({required String url}) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/image.jpg');
    await file.writeAsBytes(bytes);
     
    //  File compressedFile=await testCompressAndGetFile(file,'${directory.path}/image2.jpg');

    String imageName = generateImageName();
    String downloadUrl =await storeFileImageStorage('${Constants.images}/$imageName',file);

    return downloadUrl;
  }

  Future<void> playAudioToText({required Uint8List audioBytes}) async{
    await audioPlayer.play(BytesSource(audioBytes));
  }  

  Future<String> storeFileImageStorage(String ref, File file) async {
    UploadTask uploadTask = firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadurl = await taskSnapshot.ref.getDownloadURL();
    return downloadurl;
  }

  String generateImageName() {
    final random = Random();
    final randomNumber = random.nextInt(10000);
    final imageName = 'image_$randomNumber.jpg';
    return imageName;
  }

  // Future<File> testCompressAndGetFile(File file, String targetPath) async {
  //   var result = await FlutterImageCompress.compressAndGetFile(
  //     file.absolute.path,
  //     targetPath,
  //     quality: 90,
     
  //   );

  //   return result as File;
  // }

  double getFileSize(File file) {
    int sizeBytes = file.lengthSync();
    double sizeInMB = sizeBytes / (1024 * 1024);
    return sizeInMB;
  }
}
