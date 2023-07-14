import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/authentication/User_Information_detail.dart';
import 'package:my_virtual_assistant/provider/authentication_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../Screens/home_screen.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  const OtpScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? smsCode;
  @override
  Widget build(BuildContext context) {
    final authRepo = Provider.of<AuthenticationProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Image(image: AssetImage("Assets/images/3 - logo.png")),
                  const SizedBox(
                    height: 50,
                  ),
                  const Text("Verification",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    "Enter the otp code sent on your device",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.deepPurple)),
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)),
                    onCompleted: (value) {
                      setState(() {
                        smsCode = value;
                      });
                      verifyOTP(smsCode: smsCode!);
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  authRepo.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.deepPurple,
                        )
                      : const SizedBox.shrink(),
                  authRepo.isSuccessful
                      ? Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.green),
                          child: const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 30,
                          ),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 25,
                  ),
                  const Text("Didn't receive any code?",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text("Resend new code",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void verifyOTP({required String smsCode}) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    authProvider.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      smsCode: smsCode,
      onSuccess: () async {
        // 1. check database if the current user exist
        bool userExits = await authProvider.checkUserExist();
        if (userExits) {
          // 2. get user data from database
          await authProvider.getUserDataFromFireStore();

          // 3. save user data to shared preferences
          await authProvider.saveUserDataToSharedPref();

          // 4. save this user as signed in
          await authProvider.setSignedIn();

          // 5. navigate to Home
          navigate(isSingedIn: true);
        } else {
          // navigate to user information screen
          navigate(isSingedIn: false);
        }
      },
    );
  }

  void navigate({required bool isSingedIn}) {
    if (isSingedIn) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UserInformation()));
    }
  }
}
