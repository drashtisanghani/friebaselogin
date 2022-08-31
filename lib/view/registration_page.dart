import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constrcter/colors.dart';
import '../constrcter/string.dart';
import '../controller/getx_controller.dart';
import '../widgets/common_TextFild.dart';
import 'logIn_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //-------------------------------------------------textEditingController--------------------------------------------------------------------//
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  //----------------------Variable-------------------------------//
  final _formKey = GlobalKey<FormState>();
  GetController controller = Get.put(GetController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('registration');
  @override
  //---------------------InitState--------------------------------//
  void initState() {
    super.initState();
    email.clear();
    pass.clear();
    controller.name.value.clear();
    controller.phoneNo.value.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///Body---------------------///
      body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                const Center(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        color: Vd.lightBlue,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),

                ///NAmeTextFild------------------------------///
                buildNameTextfild(),
                const SizedBox(
                  height: 10,
                ),

                ///EamilTextFild------------------------------///
                buildEamilTextfild(),
                const SizedBox(
                  height: 20,
                ),

                ///PasswordTextFild------------------------------///
                buildPassTextfild(),
                const SizedBox(
                  height: 20,
                ),

                ///PhoneNoTextFild------------------------------///
                buildPhoneNoTextfild(),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 200,

                  ///ElevatedButton-----------------------------------///
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Vd.lightBlue)),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {}
                        try {
                          await _auth
                              .createUserWithEmailAndPassword(
                                  email: email.value.text.toString().trim(),
                                  password: pass.value.text.toString().trim())
                              .then((value) {
                            _users.add({
                              "name": controller.name.value.text,
                              "email": email.value.text,
                              "password": pass.value.text,
                              "phone no ": controller.phoneNo.value.text
                            });
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    ///LogInPage---------------------------------------///
                                    builder: (context) => const LoginPage(),
                                  ),
                                  (route) => false);
                            });
                          });
                        } catch (e) {

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              elevation: 10,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              backgroundColor: Vd.lightBlue,
                              content: Text(
                                  "User Already exist,Please try another email address.")));
                        }
                      },
                      child: const Text("Sign Up",
                          style: TextStyle(color: Vd.black))),
                ),
              ],
            ),
          )),
    );
  }

//----------------------------------------------------------------------Helper Widgets--------------------------------------------------------//
  Widget buildNameTextfild() {
    ///NameTextFild------------------------------///
    return BuildTextFild(
      validator: (val) => val!.isEmpty ? "Please enter Name" : null,
      errorText: controller.nameError,
      maxLength: null,
      keyboardType: TextInputType.emailAddress,
      fillColor: Vd.lightBlue,
      controller: controller.name.value,
      hintText: "Name",
      prefixIcon: const Icon(Icons.account_circle_rounded, color: Vd.white),
    );
  }

  ///EamilTextFild------------------------------///
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

  ///PasswordTextFild------------------------------///
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
      errorText: controller.errorPass.toString(),
      controller: pass,
      prefixIcon: const Icon(Icons.password, color: Colors.white),
      fillColor: Vd.lightBlue,
    );
  }

  ///PhoneNoTextFild------------------------------///
  Widget buildPhoneNoTextfild() {
    return BuildTextFild(
      validator: (val) => val!.isEmpty ? "Please enter Phone Number" : null,
      errorText: controller.phoneNoError,
      maxLength: 10,
      keyboardType: TextInputType.phone,
      fillColor: Vd.lightBlue,
      controller: controller.phoneNo.value,
      hintText: "Phone No.",
      prefixIcon: const Icon(Icons.phone, color: Vd.white),
    );
  }
}
