import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_virtual_assistant/Screens/Otp_Screen.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../utility/utility.dart';

class AuthenticationProvider extends ChangeNotifier{
  bool _isLoading=true;
  bool _isSuccessful=false;
  String? _uid;
  String? _phoneNumber;

  bool get isLoading=>_isLoading;
  bool get isSuccessful=>_isSuccessful;
  String? get uid=>_uid;
  String? get phoneNumber=>_phoneNumber;

  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore =FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage=FirebaseStorage.instance;

  void signInWithPhone({
  required BuildContext context,
    required String phoneNumber,
    required RoundedLoadingButtonController btnController,
}) async{
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception(e.toString());
        },
        codeSent: (String verificationId, int? resendToken) {
          _phoneNumber=phoneNumber;
          notifyListeners();
          btnController;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>OTPSCREEN(
            VerificationId: verificationId,
          )));
        },
      );
    } on FirebaseException catch(e){
      btnController.reset();
      showSnackBar(context: context, content: e.toString());
    }
  }

void verifyOtp({
    required BuildContext context,
  required String verificationId,
  required String smsCode,
  required Function onSuccess,
}) async{
    _isLoading=true;
    notifyListeners();
    try{
        PhoneAuthCredential phoneAuthCredential=PhoneAuthProvider.credential(
            verificationId: verificationId, smsCode: smsCode);
        User? user=(await firebaseAuth.signInWithCredential(phoneAuthCredential)).user;
        if(user!=null){
         _uid=user.uid;
         notifyListeners();
         onSuccess();
        }
        _isLoading=false;
        _isSuccessful=true;
        notifyListeners();
    }
    on FirebaseException catch(e){
      _isLoading=false;
      notifyListeners();
      showSnackBar(context: context, content: e.toString());
    }
}
}