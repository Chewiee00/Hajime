import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test1/api/firebase_auth_api.dart';

class AuthenticationProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj;

  AuthenticationProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $newUser');
      notifyListeners();
    }, onError: (e) {
      // provide a more useful error
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  }

  String getUser() {
    return user!.uid;
  }

  User? get user => userObj;

  bool get isAuthenticated {
    return user != null;
  }

  Future<String> signIn(String email, String password) {
    return authService.signIn(email, password);
  }

  void signOut() {
    authService.signOut();
  }

  Future<String> signUp(String email, String password, int userType,
      Map<String, dynamic> userInfo) async {
    return authService.signUp(email, password, userType, userInfo);
  }
}
