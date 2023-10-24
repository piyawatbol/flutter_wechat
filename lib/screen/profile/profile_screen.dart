import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat/api/auth.dart';
import 'package:we_chat/api/google_auth.dart';
import 'package:we_chat/controller/users_controller.dart';
import 'package:we_chat/screen/widget/colors.dart';
import 'package:we_chat/widget/auto_text.dart';
import 'package:we_chat/widget/google_fonst_style.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;
  String? _image;
  pickImage() async {
    pickedFile = (await _picker.pickImage(source: ImageSource.gallery));
    setState(() {
      _image = pickedFile!.path;
      print(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: AutoText("Profile"),
        ),
        body: Container(
            width: size.width,
            height: size.height,
            child: GetBuilder(
              init: UserController(),
              builder: (controller) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildImage(controller),
                        AutoText("${APIs.me.email}"),
                        SizedBox(height: 40),
                        TextFormField(
                          controller: controller.name,
                          style: textGoogleStyle(),
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: controller.email,
                          style: textGoogleStyle(),
                          decoration:
                              InputDecoration(border: OutlineInputBorder()),
                        ),
                        SizedBox(height: 20),
                        buildupdateButton(context, controller),
                        SizedBox(height: 20),
                        buildLogoutButton(context)
                      ],
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget buildImage(UserController controller) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(top: size.height * 0.07, bottom: size.height * 0.05),
      child: Stack(
        children: [
          _image != null
              ? CircleAvatar(
                  radius: size.width * 0.16,
                  backgroundImage: FileImage(File(pickedFile!.path)),
                )
              : CircleAvatar(
                  radius: size.width * 0.16,
                  backgroundImage: NetworkImage("${APIs.me.image}"),
                ),
          Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  pickImage();
                },
                child: CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 20,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget buildupdateButton(context, UserController controller) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.65,
      height: size.height * 0.06,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(primaryColor),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
          elevation: MaterialStateProperty.all<double>(5),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // set border radius
            ),
          ),
        ),
        onPressed: () {
          if (_image != null) {
            controller.updateProfilePicture(File(pickedFile!.path));
            controller.updateUser();
          } else {
            controller.updateUser();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_upload_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            AutoText("Update", color: Colors.white)
          ],
        ),
      ),
    );
  }

  Widget buildLogoutButton(context) {
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.65,
      height: size.height * 0.06,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
          elevation: MaterialStateProperty.all<double>(5),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0), // set border radius
            ),
          ),
        ),
        onPressed: () {
          GoogleSigninAPI.LogoutGoogle();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: Colors.white,
            ),
            SizedBox(width: 10),
            AutoText("Logout", color: Colors.white)
          ],
        ),
      ),
    );
  }
}
