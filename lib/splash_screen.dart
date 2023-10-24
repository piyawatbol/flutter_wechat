import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart'; // อย่าลืมตัวนี้
import 'package:we_chat/api/auth.dart';
import 'package:we_chat/screen/home/home_screen.dart';
import 'package:we_chat/screen/login/login_screen.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  getData() {
    if (FirebaseAuth.instance.currentUser != null) {
      APIs.getSelfInfo();
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: AnimatedSplashScreen(
            splash: Center(
              child: SizedBox(
                  width: 1000,
                  height: 1000,
                  child: Image.asset("assets/images/conversation.png")),
            ),
            splashIconSize: 250,
            backgroundColor: Colors.white,
            duration: 2000,
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            nextScreen: FirebaseAuth.instance.currentUser != null
                ? HomeScreen()
                : LoginScreen()),
      ),
    );
  }
}
