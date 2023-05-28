import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  TextEditingController phoneController=TextEditingController();
  TextEditingController nameController=TextEditingController();
  @override
  void dispose() {

    phoneController.dispose();
    nameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  RoundedLoadingButtonController btnController=RoundedLoadingButtonController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25,horizontal: 35),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundImage: AssetImage('Assets/images/user_icon.png'),
                        ),
                        Positioned(
                            bottom: 0,right: 0,child: Container(
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            border: Border.all(width: 2,color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(35))
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: IconButton(
                              icon: Icon(Icons.camera_alt,color: Colors.white,), onPressed: () {                          },
                            ),
                          ),
                        ),)
                      ],
                    ),
                  ),
                   SizedBox(height: 20,),
                  Container(width: MediaQuery.of(context).size.width,
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
                            enabled: true),
                        SizedBox(
                          height: 15,
                        ),
                        myTextFormField(
                            hintText: "Enter your PhoneNumber!.",
                            icon: Icons.phone,
                            textInputType: TextInputType.number,
                            maxLines: 1,
                            maxLength: 10,
                            textEditingController: nameController,
                            enabled: false),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: RoundedLoadingButton(controller: btnController,
                      onPressed: () {

                      },
                      successIcon: Icons.check,
                      successColor:Colors.green,
                      errorColor: Colors.red,
                      color: Colors.deepPurple,
                      child: Text('Login',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,
                          letterSpacing: 1.5),),
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
}

Widget myTextFormField({
  required String hintText,
  required IconData icon,
required TextInputType textInputType,
required int maxLines,
required maxLength,
required TextEditingController textEditingController,
required bool enabled,}){
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
        child: Icon(icon,size: 20,color: Colors.deepPurple,),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:BorderRadius.circular(15) ,
        borderSide:BorderSide(color: Colors.transparent) ,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:BorderRadius.circular(30) ,
        borderSide:BorderSide(color: Colors.transparent) ,
      ),
      hintText: hintText,
      alignLabelWithHint: true,
      border: InputBorder.none,
      fillColor: Colors.purple.shade50,
      filled: true
    ),
  );
}

