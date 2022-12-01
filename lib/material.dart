import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _email = "";
  String _password = "";
  String _nickname = "";

  String get email => _email;
  String get password => _password;
  String get univ => _nickname;

  void set email(String input_email) {
    _email = input_email;
    notifyListeners();
  }

  void set password(String input_password) {
    _password = input_password;
    notifyListeners();
  }

  void set univ(String input_nickname) {
    _nickname = input_nickname;
    notifyListeners();
  }
}

