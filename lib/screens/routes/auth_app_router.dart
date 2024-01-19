import 'package:flutter/material.dart';
import 'package:web_auth/screens/authentication/forgot_pass_screen.dart';
import 'package:web_auth/screens/authentication/login_screen.dart';
import 'package:web_auth/screens/authentication/signup_screen.dart';
import 'package:web_auth/screens/home/home_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case SignUpScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );
      case ForgotPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => ForgotPasswordScreen(),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Text('This page doesn\'t exist'),
          ),
        );
    }
  }
}
