import 'package:flutter/material.dart';
import 'package:web_auth/screens/authentication/forgot_pass.dart';
import 'package:web_auth/screens/authentication/login.dart';
import 'package:web_auth/screens/authentication/signup.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Authentication',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}






