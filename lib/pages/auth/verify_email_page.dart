import 'dart:async';

import 'package:animap/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({ Key? key }) : super(key: key);

  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> 
{
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;

  String? email = FirebaseAuth.instance.currentUser!.email;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) 
    {
      sendVerificationEmail();

      timer = Timer.periodic
      (
        Duration(seconds: 3), 
        (_) {checkEmailVerified();}
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async
  {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) 
    {
      timer?.cancel();
    }
  }

  Future sendVerificationEmail() async 
  {
    try 
    {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {canResendEmail = false;});
      await Future.delayed(Duration(seconds: 5));
      setState(() {canResendEmail = true;});

    } catch (e)
    {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) 
  {
    return isEmailVerified ? ProfilePage() : Scaffold
    (
      body: SafeArea
      (
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center
          (
            child: Column
            (
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
              [
                Text
                (
                  "Verification link on your Email",
                  textAlign: TextAlign.center,
                  style: TextStyle
                  (
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 4,),
                Text
                (
                  email??"",
                  textAlign: TextAlign.center,
                  style: TextStyle
                  (
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20,),
                Text
                (
                  "If you don't receive the link, please check your spam folder or clik the button below",
                  textAlign: TextAlign.center,
                  style: TextStyle
                  (
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.secondary
                  ),
                ),
                SizedBox(height: 20,),
                ElevatedButton.icon
                (
                  style: ElevatedButton.styleFrom
                  (
                    minimumSize: Size.fromHeight(50)
                  ),
                  icon: Icon(Icons.mail, size: 28,), 
                  label: Text
                  (
                    "Resend Email",
                    style: TextStyle
                      (
                        fontSize: 18
                      ),
                    ),
                  onPressed: sendVerificationEmail 
                ),
                SizedBox(height: 8,),
                TextButton
                (
                  onPressed: () 
                  {
                    FirebaseAuth.instance.signOut();
                  }, 
                  child: Text
                  (
                    "Cancel",
                    style: TextStyle
                    (
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.secondary
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}