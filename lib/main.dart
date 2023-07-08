import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/authentication/User_Information_detail.dart';
import 'package:my_virtual_assistant/Screens/home_screen.dart';
import 'package:my_virtual_assistant/authentication/landing_screen.dart';
import 'package:my_virtual_assistant/authentication/registration_screen.dart';
import 'package:my_virtual_assistant/provider/authentication_provider.dart';
import 'package:my_virtual_assistant/provider/chat_provider.dart';
import 'package:my_virtual_assistant/provider/my_theme_provider.dart';
import 'package:my_virtual_assistant/theme/my_theme.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=>MyThemeProvider()),
    ChangeNotifierProvider(create: (_)=>AuthenticationProvider()),
    ChangeNotifierProvider(create: (_)=>chatProvider())
  ],
  child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<MyThemeProvider>(
      builder: (BuildContext context,value,Widget? child){
      return  MaterialApp(
          title: 'Virtual Assistant',

          theme: MyTheme.themeData(isDarkTheme: value.themeType , context: context),
          debugShowCheckedModeBanner: false,

          initialRoute: Constants.landingScreen,
        routes: {
          Constants.landingScreen : (context)=>LandingScreen(),
            Constants.registrationScreen : (context)=>RegistrationScreen(),
          Constants.homeScreen : (context)=>HomeScreen(),
          Constants.userInformationScreen : (context)=>UserInformation(),
        },
        );
      },
    );
  }
}

// appBar: AppBar(
// flexibleSpace: Container(
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [
// Colors.purpleAccent.shade100,
// Colors.deepPurple
// ]
// )
// ),
// ),

