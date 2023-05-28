import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/Screens/User_Information_detail.dart';
import 'package:my_virtual_assistant/provider/authentication_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OTPSCREEN extends StatefulWidget {
  final String VerificationId;
  const OTPSCREEN({Key? key, required this.VerificationId}) : super(key: key);

  @override
  State<OTPSCREEN> createState() => _OTPSCREENState();
}

class _OTPSCREENState extends State<OTPSCREEN> {
  String? smsCode;
  @override
  Widget build(BuildContext context) {
    final authRepo=Provider.of<AuthenticationProvider>(context,listen: true);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Image(image: AssetImage("Assets/images/3 - logo.png")),

                  SizedBox(height: 50,),

                  Text("Verification", style: TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold)),

                  SizedBox(height: 18,),

                  Text("Enter the otp code sent on your device",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),),

                  SizedBox(height: 20,),

                  Pinput(
                    length: 6,
                    showCursor: true,
                    defaultPinTheme: PinTheme(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.deepPurple)
                        ),
                        textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600)
                    ),
                    onCompleted: (value) {
                      setState(() {
                        smsCode=value;
                      });
                      verifyOTP(smsCode: smsCode!);
                    },
                  ),
                  SizedBox(height: 25,),

                  authRepo.isLoading?CircularProgressIndicator(color: Colors.deepPurple,)
                  :SizedBox.shrink(),
                  authRepo.isSuccessful?Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,color: Colors.green
                    ),
                    child: Icon(Icons.done,color: Colors.white,size: 30,),
                  ):SizedBox.shrink(),
                  SizedBox(height: 25,),
                  Text("Didn\'t receive any code?", style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(height: 16,),
                  Text("Resend new code",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600
                          , color: Colors.deepPurple))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
    void verifyOTP({required String smsCode}){
      final authRepo=Provider.of<AuthenticationProvider>(context,listen: false);
      authRepo.verifyOtp(
          context:context , verificationId: widget.VerificationId,
          smsCode: smsCode, onSuccess: (){
            Navigator.push(context, MaterialPageRoute
              (builder: (context)=>UserInformation()));
      });

    }
}
