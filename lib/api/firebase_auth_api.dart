import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  Future<String> signIn(String email, String password) async {
    UserCredential credential;
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.toString();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful than just print an error message to improve UI/UX
        return 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.code;
      }
    }
  }

  Future<String> signUp(String email, String password, int userType,
      Map<String, dynamic> userInfo) async {
    UserCredential credential;

    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        saveToFirestore(credential.user?.uid, email, userType, userInfo);
      }
      return credential.toString();
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        return ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return ('The account already exists for that email.');
      }
    }
    return 'default';
  }

  void signOut() async {
    auth.signOut();
  }

  void saveToFirestore(String? uid, String email, int userType,
      Map<String, dynamic> userInfo) async {
    try {
      if (userType == 0) {
        await db.collection("team").doc(uid).set({
          'id': uid,
          'name': userInfo['name'],
          'code': userInfo['code'],
          // 'address': userInfo['address'],
          // 'contactnumber': userInfo['contactnumber'],
          'players': [],
          'matchlogs': [],
          'logs': []
        });
      } else {
        await db.collection("player").doc(uid).set({
          'id': uid,
          'teamid': null,
          'displayname': userInfo['displayname'],
          'email': email,
          'teamname': userInfo['teamname'],
          'sex': userInfo['sex'],
          'birthdate': userInfo['birthdate'],
          'trainingdateStart': userInfo['trainingdateStart'],
          'beltcolor': userInfo['beltcolor'],
          'contactnumber': userInfo['contactnumber'],
          'height': userInfo['height'],
          'weight': userInfo['weight'],
          'elo': 1200,
          'logs': [],
          'matchlogs': [],
        });
      }
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
