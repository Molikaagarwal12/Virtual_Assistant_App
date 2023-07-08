import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:my_virtual_assistant/Screens/home_screen.dart';
import 'package:my_virtual_assistant/model/user_model.dart';
import 'package:my_virtual_assistant/provider/authentication_provider.dart';
import 'package:my_virtual_assistant/utility/utility.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  File? finalImageFile;

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final authProvider = Provider.of<AuthenticationProvider>(
        context, listen: false);
    phoneController.text = authProvider.phoneNumber;
  }

  RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  void selectImage(bool fromCamera) async {
    finalImageFile = await pickImage(context: context, fromCamera: fromCamera);
    cropImage(finalImageFile!.path);
  }

  void cropImage(filePath) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath, maxHeight: 800, maxWidth: 100);
    popTheImageDialog();
    if (croppedFile != null) {
      setState(() {
        finalImageFile = File(croppedFile.path);
      });
    }
  }

  void popTheImageDialog() {
    Navigator.pop(context);
  }

  void showImagePickerDialog() {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Please choose an option"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                selectImage(true);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.camera, color: Colors.purple,),
                  ),
                  Text("Camera")
                ],
              ),
            ),
            InkWell(
              onTap: () {
                selectImage(false);
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.browse_gallery, color: Colors.purple,),
                  ),
                  Text("Gallery")
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
              child: Column(
                children: [
                  Center(
                    child: finalImageFile == null
                        ? Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage:
                          AssetImage('Assets/images/user_icon.png'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              border: Border.all(
                                  width: 2, color: Colors.white),
                              borderRadius:
                              BorderRadius.all(Radius.circular(35)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showImagePickerDialog();
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                        : finalImageFile!.path.isNotEmpty
                        ? Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage:
                          FileImage(File(finalImageFile!.path)),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              border: Border.all(
                                  width: 2, color: Colors.white),
                              borderRadius:
                              BorderRadius.all(Radius.circular(35)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showImagePickerDialog();
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                        : CircularProgressIndicator(),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        myTextFormField(
                          hintText: "Enter your name!.",
                          icon: Icons.account_circle,
                          textInputType: TextInputType.text,
                          maxLines: 1,
                          maxLength: 25,
                          textEditingController: nameController,
                          enabled: true,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        myTextFormField(
                          hintText: "Enter your PhoneNumber!.",
                          icon: Icons.phone,
                          textInputType: TextInputType.number,
                          maxLines: 1,
                          maxLength: 10,
                          textEditingController: phoneController,
                          enabled: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RoundedLoadingButton(
                      controller: btnController,
                      onPressed: () {
                        saveUserDataToFirestore();
                      },
                      successIcon: Icons.check,
                      successColor: Colors.green,
                      errorColor: Colors.red,
                      color: Colors.deepPurple,
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget myTextFormField({
    required String hintText,
    required IconData icon,
    required TextInputType textInputType,
    required int maxLines,
    required maxLength,
    required TextEditingController textEditingController,
    required bool enabled,}) {
    return TextFormField(
      enabled: enabled,
      cursorColor: Colors.orangeAccent,
      controller: textEditingController,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
          counterText: '',
          prefixIcon: Container(
            margin: EdgeInsets.all(8),
            child: Icon(icon, size: 20, color: Colors.deepPurple,),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: Colors.purple.shade50,
          filled: true
      ),
    );
  }
void saveUserDataToFirestore() async{
    final authProvider=context.read<AuthenticationProvider>();
    UserModel userModel=UserModel(uid: authProvider.uid!,
        name: nameController.text,
        profilePic: '',
        phone:phoneController.text,
        aboutMe: '',
        lastSeen: '',
        dateJoined: '',
        isOnline: true,);
 if(finalImageFile!=null){
   if(nameController.length>=3){
     authProvider.saveUserDataToFireStore(
         context: context,
         userModel: userModel,
         fileImage: finalImageFile!,
         onSuccess:() async{
           await authProvider.saveUserDataToSharedPref();
           await authProvider.setSignedIn();
           navigateToHomeScreen();

         },
         );
   }else{
     btnController.reset();
     showSnackBar(context: context, content: "Please select an image");
   }
 }else{
   btnController.reset();
   showSnackBar(context: context, content: "Please select an image");
 }
}

  void navigateToHomeScreen() {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(
        builder: (context)=>HomeScreen()),
            (route)=>false );
  }
}
