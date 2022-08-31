import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/responseModle.dart';

//-------------------------------------------------LogInApiProvider-------------------------------------------------------------------------//
class LoginApiProvider {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? user;
  Future<ResponseModel<UserCredential>> loginApi(
      {required String email, required String password}) async {
    try {
      user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user?.user?.uid != null) {
        return ResponseModel<UserCredential>(
          status: 200,
          data: user,
        );
      } else {
        return ResponseModel<UserCredential>(
          status: 400,
        );
      }
    } on FirebaseAuthException catch (e) {
      return ResponseModel<UserCredential>(
          status: 400, message: e.message.toString());
    }
  }
}



//--------------------------------------------------GoogleSignIn-------------------------------------------------------------------------//
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('registration');

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      var user = userCredential.user;
      var email = user?.email;
      var name = user!.displayName;
      var id = user.uid;
      var createTime = user.metadata.creationTime.toString();
      var lastTime = user.metadata.lastSignInTime.toString();

      _users.add({
        "name": name,
        "id": id,
        "email": email,
        "createTime": createTime,
        "lastTime": lastTime
      });
    } on FirebaseAuthException {
      rethrow;
    }
    return null;
  }

  Future<void> signOutFromGoogle() async {
    await _auth.signOut().then((value) {
      _googleSignIn.signOut();
    });
  }
}

