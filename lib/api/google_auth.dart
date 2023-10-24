import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/api/auth.dart';
import 'package:we_chat/controller/loading_controller.dart';

class GoogleSigninAPI {
  static Future LoginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    LoadingController loadingController = Get.put(LoadingController());
    if (googleUser == null) {
      loadingController.setLoading(false);
    }
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // print(googleAuth?.accessToken);

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static LogoutGoogle() async {
    await APIs.updateActiveStatus(false);
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAndToNamed('/login_screen');
  }
}
