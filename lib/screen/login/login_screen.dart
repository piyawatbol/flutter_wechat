import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_chat/controller/loading_controller.dart';
import 'package:we_chat/controller/login_controller.dart';
import 'package:we_chat/widget/loading.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoadingController loadingController = Get.put(LoadingController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        child: SafeArea(
            child: GetBuilder<LoginController>(
          init: LoginController(),
          builder: (controller) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildIcon(),
                    buildGoogleButton(controller),
                  ],
                ),
                GetBuilder<LoadingController>(
                  builder: (controller) {
                    return Loading(statusLoading: controller.statusLoading);
                  },
                ),
              ],
            );
          },
        )),
      ),
    );
  }

  buildIcon() {
    var size = MediaQuery.of(context).size;
    return Image.asset(
      "assets/images/conversation.png",
      width: size.width * 0.8,
      height: size.height * 0.5,
    );
  }

  buildGoogleButton(LoginController controller) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.65,
      height: size.height * 0.06,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
          elevation: MaterialStateProperty.all<double>(5),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // set border radius
            ),
          ),
        ),
        onPressed: () {
          controller.LoginGoogle();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/google.png",
              width: size.width * 0.1,
              height: size.height * 0.03,
            ),
            SizedBox(width: size.width * 0.02),
            Text(
              "SignIn With Google",
              style: TextStyle(color: Colors.black),
            )
          ],
        ),
      ),
    );
  }
}
