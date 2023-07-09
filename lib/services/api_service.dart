import 'dart:convert';
import 'dart:io';

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
              {"role": "user", "content": message}
          })
        );
        Map jsonResponse=jsonDecode(response.body);

        if(jsonResponse['error']!=null){
          throw HttpException(jsonResponse['error']['message']);
        }
        String answer="";
        if(jsonResponse['choices'].length>0){
          print('ANSWER : ${jsonResponse['choices'][0]['messages']['content']}');
          answer=jsonResponse['choices'][0]['messages']['content'];
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
            '$baseUrl/chat/completions'),
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
          print('ANSWER : ${jsonResponse['choices'][0]['messages']['content']}');
          imageUrl=jsonResponse['data'][0]['url'];
        }
        return imageUrl;
      }catch(error){
        print(error);
        rethrow;
      }
    }
  }
}