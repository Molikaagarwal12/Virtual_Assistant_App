import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/authentication/User_Information_detail.dart';
import 'package:my_virtual_assistant/authentication/registration_screen.dart';
import 'package:provider/provider.dart';

import '../Screens/home_screen.dart';
import '../provider/authentication_provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    checkAuthentication();
    super.initState();
  }
 void checkAuthentication() async{
   final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
   if(await authProvider.checkSignedIn()){
     await authProvider.checkSignedIn();
     await authProvider.getUserDataFromSharedPref();
     navigate(isSingedIn: true);
   }else{
     navigate(isSingedIn: false);
   }
 }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.orangeAccent,
        ),
      ),
    );
  }

  void navigate({required bool isSingedIn}) {
    // Add your navigation logic here
    if(isSingedIn){
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(
          builder: (context) => const HomeScreen()), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(
              builder: (context) => const RegistrationScreen()), (route) => false);
    }
  }
}


