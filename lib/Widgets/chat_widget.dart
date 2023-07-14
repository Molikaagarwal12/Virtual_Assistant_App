import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/services/image_cache_manager.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../provider/authentication_provider.dart';
import '../provider/my_theme_provider.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget(
      {super.key,
      required this.message,
      required this.senderId,
      required this.isText});

  final String message;
  final String senderId;
  final bool isText;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<MyThemeProvider>(context).themeType;
    final color = isDarkTheme ? Colors.white : Colors.black;
    var user = context.read<AuthenticationProvider>().userModel;
    return Column(
      children: [
        !isDarkTheme
            ? Material(
                color:
                    senderId == user.uid ? Colors.grey.shade300 : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        senderId == user.uid
                            ? CircleAvatar(
                                key: UniqueKey(),
                                radius: 15,
                                backgroundImage: CachedNetworkImageProvider(
                                  user.profilePic,
                                  cacheManager:
                                      MyImageCacheManager.profileCacheManager,
                                ))
                            : Image.network(
                                'https://static.vecteezy.com/system/resources/previews/021/495/996/original/chatgpt-openai-logo-icon-free-png.png',
                                height: 30,
                                width: 30,
                              ),
                        const SizedBox(
                          width: 8,
                        ),
                        senderId == user.uid
                            ? Expanded(
                                child: SelectableText(
                                message.trim(),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ))
                            : Expanded(
                                child: isText
                                    ? SelectableText(
                                        message.trim(),
                                        style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: message,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.orangeAccent,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(
                                                child: Icon(
                                          Icons.error,
                                          color: Colors.red,
                                        )),
                                        cacheManager: MyImageCacheManager.generatedImageCacheManager, 
                                      ))
                      ]),
                ),
              )
            : Material(
                color: senderId == user.uid
                    ? Constants.chatGPTDarkScaffoldColor
                    : Constants.chatGPTDarkCardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        senderId == user.uid
                            ? CircleAvatar(
                                key: UniqueKey(),
                                radius: 15,
                                backgroundImage: CachedNetworkImageProvider(
                                  user.profilePic,
                                  cacheManager:
                                      MyImageCacheManager.profileCacheManager,
                                ),
                              )
                            : Image.network(
                                'https://static.vecteezy.com/system/resources/previews/021/495/996/original/chatgpt-openai-logo-icon-free-png.png',
                                height: 30,
                                width: 30,
                              ),
                        const SizedBox(
                          width: 8,
                        ),
                        senderId == user.uid
                            ? Expanded(
                                child: SelectableText(
                                message.trim(),
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ))
                            : Expanded(
                                child: isText
                                    ? SelectableText(
                                        message.trim(),
                                        style: TextStyle(
                                            color: color,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16),
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: message,
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.orangeAccent,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Center(child: Icon(Icons.error,color: Colors.red,)),
                                            cacheManager: MyImageCacheManager.generatedImageCacheManager, 
                                      )
                                      )
                      ]),
                ),
              )
      ],
    );
  }
}
