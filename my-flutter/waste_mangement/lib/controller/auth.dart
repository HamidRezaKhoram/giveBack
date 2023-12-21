import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController {
  Future<void> signUp(
      String email, String password, VoidCallback onSignUpSuccess) async {
    var client = http.Client();
    try {
      final response = await client.post(
        Uri.http('localhost:8080',
            '/receiver'), // Use Uri.https for production
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', json.encode(responseData));
        await prefs.setBool('isLoggedIn', true);

        onSignUpSuccess(); // Call the callback function on successful sign-up
      } else {
        debugPrint(response.body);
      }
    } catch (error) {
      debugPrint(error.toString());
      // Handle errors
    }
  }
}
