import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:we_chat/api/auth.dart';
import 'package:we_chat/api/google_auth.dart';
import 'package:we_chat/controller/loading_controller.dart';

class LoginController extends GetxController {
  LoadingController loadingController = Get.put(LoadingController());
  LoginGoogle() async {
    loadingController.setLoading(true);
    UserCredential userData = await GoogleSigninAPI.LoginWithGoogle();
    print("user : ${userData}");
    if ((await APIs.userExists())) {
      APIs.getSelfInfo();
      Get.offAllNamed('/home_screen');
    } else {
      APIs.createUser().then((value) {
        Get.offAllNamed('/home_screen');
      });
    }
  }
}
