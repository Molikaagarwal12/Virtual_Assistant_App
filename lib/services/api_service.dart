// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';

class ApiService{
  static Future<String> SendMessageToChatGpt({
  required String message,
    required String modelId,
    required bool isText
}) async{
    if(isText){
      try{
        var response=await http.post(Uri.parse(
          '$baseUrl/chat/completions'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $chatGptApiKey"
        },
          body: jsonEncode({
            "model": modelId,
            "messages":
              [{"role": "user", "content": message}]
          })
        );
        Map jsonResponse=jsonDecode(response.body);

        if(jsonResponse['error']!=null){
          throw HttpException(jsonResponse['error']['message']);
        }
        String answer="";
        if(jsonResponse['choices'].length>0){
          print('ANSWER : ${jsonResponse['choices'][0]['message']['content']}');
          answer=jsonResponse['choices'][0]['message']['content'];
        }
        return answer;
      }catch(error){
        print(error);
        rethrow;
      }
    }
    else{
      try{
        var response=await http.post(Uri.parse(
            '$baseUrl/images/generations'),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer $chatGptApiKey"
            },
            body: jsonEncode({
              "prompt":message  ,
              "n": 2,
              "size": "1024x1024"
            })
        );
        Map jsonResponse=jsonDecode(response.body);

        if(jsonResponse['error']!=null){
          throw HttpException(jsonResponse['error']['message']);
        }
        String imageUrl="";
        if(jsonResponse['data'].length>0){
          print('ANSWER : ${jsonResponse['data'][0]['url']}');
          imageUrl=jsonResponse['data'][0]['url'];
        }
        return imageUrl;
      }catch(error){
        print(error);
        rethrow;
      }
    }
  }
   static Future<Uint8List> fetchAudioBytes({
   required String text,

     required voiceId,
  }) async {
    
      try{

        var response = await http.post(
            Uri.parse('$elevenLabsBaseUrl/21m00Tcm4TlvDq8ikWAM'),
            headers: {
              "Content-Type": "application/json",
              "xi-api-key": " $elevenLabsApiKey"
            },
            body: jsonEncode(
                {
 "key":elevenLabsApiKey, 
 "text":text, 
  "voice_settings": {
    "stability": 0,
    "similarity_boost": 0,
  },
     'hi':'en-us',
     "c":'WAV',
      'f':'44hz_16bit_sterio'
                }
            )
        );

       if(response.statusCode == 200)
{
  final bytes=response.bodyBytes;
  return bytes;

}else{
  throw Expando('Failed to load audio');
}
       
       
      } catch (error){
        print(error);
        rethrow;
      }
    }
  }