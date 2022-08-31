// ignore_for_file: file_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, duplicate_ignore

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/constrcter/image.dart';
import 'package:firebase_login/view/registration_page.dart';
import 'package:firebase_login/view/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../apiProvider/login_api_provider.dart';
import '../constrcter/colors.dart';
import '../constrcter/string.dart';
import '../controller/getx_controller.dart';
import '../models/responseModle.dart';
import '../widgets/common_TextFild.dart';
import 'forgotpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //-----------------------------------------------get Controller--------------------------------------------------------------------//
  GetController controller = Get.put(GetController());
  LoginApiProvider loginApiProvider = LoginApiProvider();
  //--------------------------------------------------------TextEditingController-----------------------------------------------------//
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  ///Variable-------------------------------///
  var showMessage;

  ///-----------------------SharedPreference------------///
  setData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("email", "success");
  }

  ///------------InitState--------------------///
  @override
  void initState() {
    super.initState();
    email.clear();
    pass.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///-----Body-----------------///
      body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const SizedBox(
          height: 40,
        ),
        const Center(
          child: Text(
            "LogIn",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
          ),
        ),
        const SizedBox(
          height: 50,
        ),

        ///EmailTextFild-----------------------///
        buildEamilTextfild(),
        const SizedBox(
          height: 20,
        ),

        ///PasswordTextFild-----------------------///
        buildPassTextfild(),

        ///TextButton------------------------------///
        TextButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  ///ForgotPasswordPage-----------------------///
                  builder: (context) => const ForgotPassword(),
                ));
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 150),
            child: Text(
              "Forgot Password?",
              style: TextStyle(color: Vd.lightBlue),
            ),
          ),
        ),
        SizedBox(
            width: 300,

            ///ElevatedButton---------------------------------///
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Vd.lightBlue)),
                onPressed: () async {
                  ResponseModel<UserCredential> response =
                      await loginApiProvider.loginApi(
                          email: email.value.text, password: pass.value.text);

                  if (response.status == 200) {
                    setData();
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        ///UserProfilePage-------------------------------------///
                        builder: (context) => const UserProfile(),
                      ),
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        backgroundColor: Vd.lightBlue,
                        content: Text(response.message.toString())));
                  }
                },
                child: const Text("LogIn"))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?",
                style: TextStyle(color: Color(0xFF6B779A))),

            ///--------TextButton------------------------///
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    ///RegisterPage---------------------------///
                    builder: (context) => const RegisterPage(),
                  ),
                );
              },
              child: const Text("Sign Up", style: TextStyle(color: Vd.black)),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ///GoogleButton-----------------------------///
            GestureDetector(
              child: const CircleAvatar(

                  ///AssetImage---------------///
                  backgroundImage: AssetImage(Images.google),
                  radius: 25),
              onTap: () async {
                setState(() {
                  controller.isLoading = true;
                });
                FirebaseService service = FirebaseService();
                try {
                  await service.signInWithGoogle();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        ///UserProfilePage----------------------------------///
                        builder: (context) => const UserProfile(),
                      ),
                      (route) => false);
                } catch (e) {
                  if (e is FirebaseAuthException) {
                    var showMessage2 = showMessage;
                    showMessage2(e.message!);
                  }
                }
                setState(() {
                  controller.isLoading = false;
                });
              },
            ),
          ],
        ),
      ]),
    );
  }

//---------------------------------------------------------------Helper Widget-------------------------------------------------------------//
  ///EmailTextFild Function///
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

  ///PasswordTextFild Function///
  Widget buildPassTextfild() {
    return CommonTextFild(
      validator: (val) =>
          val!.length <= 8 ? "Please enter more than 8 character" : null,
      name: 'Password',
      hintText: "Password",
      obscureText: Strings.hidden,
      suffixIcon: IconButton(
          color: Colors.grey,
          icon: (Strings.hidden)
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
          onPressed: () {
            setState(() {
              Strings.hidden = !Strings.hidden;
            });
          }),
      errorText: controller.errorPass.value,
      controller: pass,
      prefixIcon: const Icon(Icons.password, color: Colors.white),
      fillColor: Vd.lightBlue,
    );
  }
}
