import 'package:flutter/material.dart';
import 'package:web_auth/data/user_repository/models/my_user.dart';
import 'package:web_auth/screens/authentication/forgot_pass_screen.dart';
import 'package:web_auth/screens/authentication/login_screen.dart';
import 'package:web_auth/screens/authentication/signup_screen.dart';
import 'package:web_auth/screens/home/home_screen.dart';
import 'package:web_auth/screens/home/post_screen.dart';

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
      case PostScreen.routeName:
        final MyUser user = settings.arguments as MyUser;
        return MaterialPageRoute(
          builder: (context) => PostScreen(user),
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
