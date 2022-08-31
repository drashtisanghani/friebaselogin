// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_login/view/logIn_page.dart';
import 'package:flutter/material.dart';

import '../constrcter/colors.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  //-----------------------------------------------------Variable--------------------------------------------------------------------------------//
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('registration');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///AppBAr-----------------------///
        appBar: AppBar(
            title: const Text("UserProfile"),
            backgroundColor: Vd.lightBlue,
            actions: [
              IconButton(
                  onPressed: () {
                    signOut();
                  },
                  icon: const Icon(Icons.logout))
            ]),
        ///Body------------------------------///
        body: StreamBuilder(
            stream: _users.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                    itemCount: streamSnapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot documentSnapshot =
                          streamSnapshot.data!.docs[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(documentSnapshot["name"]),
                          subtitle: Text(documentSnapshot["email"].toString()),
                        ),
                      );
                    });
              }
              return const Center(child: CircularProgressIndicator());
            }));
  }
///SignOut Function-----------------------------///
  signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      ///LogInPage-----------------------------///
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }
}
