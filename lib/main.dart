import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/view/logIn_page.dart';
import 'package:firebase_login/view/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? store = sharedPreferences.getString("email");

  runApp(
    GetMaterialApp(
      home: (store == "success") ? const UserProfile() : const LoginPage(),
    ),
  );
}
