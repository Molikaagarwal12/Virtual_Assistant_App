

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../provider/authentication_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController phoneController=TextEditingController();
   // ignore: non_constant_identifier_names
   Country SelectedCountry=Country(
       phoneCode: '91',
       countryCode:'IN',
       e164Sc: 0, geographic: true,
       level: 1,
       name: 'India',
       example: 'India',
       displayName: 'India',
       displayNameNoCountryCode: 'IN',
       e164Key: '');

   RoundedLoadingButtonController btnController=RoundedLoadingButtonController();
   @override
  void dispose() {

     phoneController.dispose();
     btnController.stop();
    
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     phoneController.selection=TextSelection.fromPosition(TextPosition(offset: phoneController.text.length));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25,horizontal: 35),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(image: AssetImage("Assets/images/3 - logo.png")),
                    const SizedBox(height: 35,),
                  // Image(image: AssetImage("Assets/images/pexels-tara-winstead-8386422.jpg")),
                  // SizedBox(height: 50,),
            const Text("   Registration",style: TextStyle(fontSize: 38,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  const SizedBox(height: 18,),
                  const Text("Add your phoneNumber. I will send you a verification code.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  const SizedBox(height: 30,),
                  TextFormField(controller: phoneController,
                  // maxLength: 10,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    onChanged: (value){
                    setState(() {
                      phoneController.text=value;
                    });
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Phone number",
                      hintStyle: const TextStyle(fontSize: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                            ,borderSide: const BorderSide(color: Colors.deepPurpleAccent)
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.deepPurpleAccent)
                      ),
                     prefixIcon: Container(
                       padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                         child: InkWell(
                           onTap: (){
                             showCountryPicker(context: context,
                                 countryListTheme: const CountryListThemeData(
                                   bottomSheetHeight: 500
                                 ),
                                 onSelect: (value){
                                   setState(() {
                                     SelectedCountry=value;
                                   });
                                 }
                                 );
                           },
                           child: Text('${SelectedCountry.flagEmoji}+${SelectedCountry.phoneCode}',
                           style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                         ),
                     ),
                      suffixIcon:phoneController.text.length>9?
                       Container(
                         height: 20, width: 20,
                         margin: const EdgeInsets.all(10),
                         decoration: const BoxDecoration(
                           shape: BoxShape.circle,color: Colors.green
                         ),
                         child
                             : const Icon(Icons.done,size: 20,color: Colors.white,),
                       )   :null,
                    ),
                  ),
                  const SizedBox(height: 22,),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: RoundedLoadingButton(controller: btnController,
                        onPressed: () {
                       sendPhoneNumber();
                        },
                        successIcon: Icons.check,
                        successColor:Colors.green,
                        errorColor: Colors.red,
                        color: Colors.deepPurple,
                        child: const Text('Sign Up',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,
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
  void sendPhoneNumber(){
    final authRepo=Provider.of<AuthenticationProvider>(context,listen:false);
    String phoneNumber=phoneController.text.trim();
    // ignore: non_constant_identifier_names
    String FullPhoneNumber='+${SelectedCountry.phoneCode}$phoneNumber';
    authRepo.signInWithPhone(context: context,
        phoneNumber: FullPhoneNumber,
        btnController: btnController);
  }

}

