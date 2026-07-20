import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  String? get token => _token;
  String? get userId => _userId;

  Future<void> signup(String email, String password) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyA7_ssudHn0YWbt6dCgmeVHAXYcRKyFg48',
    );

    try {
      final request = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final response = json.decode(request.body);
      print(response);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyA7_ssudHn0YWbt6dCgmeVHAXYcRKyFg48',
    );

    try {
      final request = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final response = json.decode(request.body);
      _token = response['idToken'];
      _userId = response['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(response['expiresIn'])),
      );
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString(('userDate'), userData);
    } catch (e) {
      throw e;
    }
  }

  void logout() {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
  }

  void _autoLogout() {
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    Timer(Duration(seconds: timeToExpiry), logout);
  }
}
