import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User? newUser) {
    _user = newUser;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }
}
