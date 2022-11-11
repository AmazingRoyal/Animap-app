import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {

  final VoidCallback? onClickSignUp;

  const LoginPage ({Key? key, required this.onClickSignUp}): super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> 
{
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() 
  {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      body: SafeArea
      (
        child: SingleChildScrollView
        (
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form
            (
              key: formKey,
              child: Column
              (
                children: [
                  SizedBox(height: 40,),
                  SvgPicture.asset
                  (
                    "assets/logo/app-logo.svg",
                    width: 200,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 40,),
                  Row
                  (
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text
                      (
                        "Login to your Account",
                        textAlign: TextAlign.left,
                        style: TextStyle
                        (
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.tertiary
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12,),
                  TextFormField
                  (
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration
                    (
                      labelText: "Email"
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) {
                      return email != null && !EmailValidator.validate(email) 
                      ? "Enter valid email"
                      : null;
                    },             
                  ),
                  SizedBox(height: 4,),
                  TextFormField
                  (
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    decoration: InputDecoration
                    (
                      labelText: "Password"
                    ),        
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value != null && value.length < 6
                      ? "Enter min. 6 char"
                      : null;
                    },      
                  ),
                  SizedBox(height: 24,),
                  ElevatedButton.icon
                  (
                    style: ElevatedButton.styleFrom
                    (
                      minimumSize: Size.fromHeight(50)
                    ),
                    icon: Icon(Icons.lock_open), 
                    label: Text
                    (
                      "Sign In",
                      style: TextStyle
                      (
                        fontSize: 18
                      ),
                    ),
                    onPressed: signIn, 
                  ),
                  SizedBox(height: 24,),
                  GestureDetector
                  (
                    child: Text
                    (
                      "Forgot Password",
                      style: TextStyle
                      (
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        decoration: TextDecoration.underline
                      ),
                    ),
                    onTap: () 
                    {
                      Navigator.push
                      (
                        context, 
                        MaterialPageRoute(builder:(context) 
                        {
                          return ForgotPasswordPage();
                        })
                      );
                    },
                  ),
                  SizedBox(height: 12), 
                  RichText
                  (
                    text: TextSpan
                    (
                      text: "Dont have an account?  ",
                      style: TextStyle
                      (
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16
                      ),
                      children: [ 
                        TextSpan
                        (
                          recognizer: TapGestureRecognizer()..onTap = widget.onClickSignUp,
                          text: "Sign Up",
                          style: TextStyle
                          (
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor
                          )
                        )
                      ]
                    )
                  )  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future signIn() async 
  {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try 
    {
      await FirebaseAuth.instance.signInWithEmailAndPassword
      (
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e)
    {
      print(e);
    }

  }

}