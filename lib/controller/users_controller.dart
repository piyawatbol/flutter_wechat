import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_chat/api/auth.dart';

class UserController extends GetxController {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  Future updateUser() {
    return APIs.firestore.collection('users').doc(APIs.user.uid).update({
      'name': name.text,
      'email': email.text,
    }).then((value) => {Get.back()});
  }

  Future updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    final ref =
        APIs.storage.ref().child('profile_pictures/${APIs.user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) => log('success'));
    var image = await ref.getDownloadURL();
    await APIs.firestore
        .collection('users')
        .doc(APIs.user.uid)
        .update({'image': image});
    await APIs.getSelfInfo();
    Get.back();
  }

  @override
  Future<void> onInit() async {
    await APIs.getSelfInfo();
    name = TextEditingController(text: APIs.me.name.toString());
    email = TextEditingController(text: APIs.me.email.toString());
    update();
    super.onInit();
  }
}
