// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final onTap;
  CustomButton(this.onTap);

  @override
  Widget build(BuildContext context) {
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
          onTap();
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
