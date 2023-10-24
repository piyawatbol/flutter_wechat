import 'dart:async';

import 'package:get/get.dart';

class LoadingController extends GetxController {
  var statusLoading = false.obs;

  setLoading(status) {
    statusLoading = RxBool(status);
    update();
    Timer(Duration(seconds: 10), () {
      statusLoading = RxBool(false);
      update();
    });
  }
}
