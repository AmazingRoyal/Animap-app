import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatefulWidget {

  final VoidCallback? onClickSignIn;

  const SignUpPage ({Key? key, required this.onClickSignIn}): super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> 
{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

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
                      "Create your Account",
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
                SizedBox(height: 4,),
                TextFormField
                (
                  controller: confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  decoration: InputDecoration
                  (
                    labelText: "Confirm Password"
                  ),   
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value != null && value != passwordController.text
                      ? "Password not match"
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
                  icon: Icon(Icons.arrow_forward, size: 28,), 
                  label: Text
                  (
                    "Sign Up",
                    style: TextStyle
                    (
                      fontSize: 18
                    ),
                  ),
                  onPressed: signUp, 
                ),              
                SizedBox(height: 24,),
                RichText
                (
                  text: TextSpan
                  (
                    text: "Already have an account?  ",
                    style: TextStyle
                    (
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16
                    ),
                    children: [ 
                      TextSpan
                      (
                        recognizer: TapGestureRecognizer()..onTap = widget.onClickSignIn,
                        text: "Sign In",
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
    );
  }
  Future signUp() async 
  {
    try 
    {
      await FirebaseAuth.instance.createUserWithEmailAndPassword
      (
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );
    } on FirebaseAuthException catch (e)
    {
      print(e);
      final snackbar = SnackBar
      (
        content: Text(e.message.toString())
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

}