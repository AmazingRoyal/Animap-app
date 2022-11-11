import 'package:animap/pages/auth/signin_page.dart';
import 'package:animap/pages/auth/signup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> 
{
  bool isLogin = true;

  void toggle() 
  {
    setState(() {
      isLogin = !isLogin;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return isLogin 
    ? LoginPage(onClickSignUp: toggle) 
    : SignUpPage(onClickSignIn: toggle);

  }
  
}