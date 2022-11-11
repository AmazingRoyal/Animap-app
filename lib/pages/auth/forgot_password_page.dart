import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({ Key? key }) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> 
{
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose()
  {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold
    (
      appBar: AppBar
      (
        title: Text("Reset Password"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea
      (
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form
          (
            key: formKey,
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text
                (
                  "Received an Email\nto reset your password",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 20,),
                TextFormField
                (
                  controller: emailController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(labelText: "Email"),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) {
                    return email != null && !EmailValidator.validate(email) 
                    ? "Enter valid email"
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
                  icon: Icon(Icons.email, size: 28,), 
                  label: Text
                  (
                    "Reset Password",
                    style: TextStyle
                    (
                      fontSize: 18
                    ),
                  ),
                  onPressed: resetPassword
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
    Future resetPassword() async 
    {
      await FirebaseAuth.instance.sendPasswordResetEmail
      (
        email: emailController.text.trim()
      );
    }
}