// ignore_for_file: use_build_context_synchronously

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/constrcter/image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constrcter/colors.dart';
import '../controller/getx_controller.dart';
import '../widgets/common_TextFild.dart';
import 'logIn_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  //-------------------------------------------------textEditingController--------------------------------------------------------------------//
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
//-------------------------------------------------------get Controller-------------------------------------------------------------------//
  GetController controller = Get.put(GetController());
  //---------------------------------------------------Variable------------------------------------------------------------------------------//
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///body--------------------///
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 100,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: CircleAvatar(
              radius: 80,
              ///------------AssetImage------------//
              backgroundImage: AssetImage(Images.forgot),
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.only(left: 40),
            child: Text(
              "Yo! Forgot Your Password?",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Vd.lightBlue),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
                "No worries! Enter your email and we will send you a reset.",
                style: TextStyle(color: Vd.lightBlue)),
          ),
          const SizedBox(height: 30),
          ///-----------------EmailTextFild------------------------///
          buildEamilTextfild(),
          const SizedBox(height: 30),
          SizedBox(
            height: 50,
            width: 200,
            ///-------------------Elevatedbutton----------------///
            child: ElevatedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )),
                  backgroundColor: MaterialStateProperty.all(Vd.lightBlue)),
              onPressed: ()  async {
                if (email.value.text.isNotEmpty) {
                  try {
                    await _auth.sendPasswordResetEmail(
                        email: email.value.text.trim());
                  } catch (e) {
                    error = e.toString();
                  }
                  if (error ==
                      "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted.") {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("User not found"),
                      ),
                    );
                  } else {
                    ///--------------------------SnackBar-------------------------//
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        backgroundColor: Vd.lightBlue,
                        content: Text("Please check Your Email")));
                    Future.delayed(
                      const Duration(seconds: 5),
                    ).then(
                      (value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          ///-------------LogInPage-----------------------///
                          builder: (context) => const LoginPage(),
                        ),
                      ),
                    );
                  }
                }
              },
              child:
                  const Text("Send Request", style: TextStyle(color: Vd.black)),
            ),
          ),
        ]),
      ),
    );
  }
//-----------------------------------------------------------helper Widget----------------------------------------------------------------------//
  Widget buildEamilTextfild() {
    return CommonTextFild(
      validator: (value) =>
          EmailValidator.validate(value!) ? null : "Please enter a valid email",
      fillColor: Vd.lightBlue,
      prefixIcon: const Icon(Icons.email, color: Colors.white),
      name: 'Email',
      hintText: "Email",
      obscureText: false,
      suffixIcon: null,
      errorText: controller.errorEmail.value,
      controller: email,
    );
  }
}
