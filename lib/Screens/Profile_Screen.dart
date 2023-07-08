import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/authentication/registration_screen.dart';
import 'package:my_virtual_assistant/provider/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../provider/my_theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeStatus=Provider.of<MyThemeProvider>(context);
    Color color=themeStatus.themeType?Colors.white:Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: Text("Nexus-VirtualAssistant",style: TextStyle(color:
        color),),
        actions: [
          IconButton(onPressed:(){
            if (themeStatus.themeType){
              themeStatus.setTheme=false;
            }else{
              themeStatus.setTheme=true;
            }
          }, icon: Icon(themeStatus.themeType?Icons.dark_mode_outlined:Icons.light_mode_outlined,color: color,)),
          IconButton(onPressed: () async{
            await context.read<AuthenticationProvider>().signOutUser();
            Navigator.pushAndRemoveUntil(
                context, MaterialPageRoute(
                builder: (context)=>RegistrationScreen()),
                    (route)=>false );
          }, icon: Icon(Icons.logout,color: color,))
        ],

      ),
      body: Center(child: Text("Profile Screen")),
    );
  }
}
