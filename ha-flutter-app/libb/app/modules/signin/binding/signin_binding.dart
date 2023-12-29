import 'package:get/get.dart';
import 'package:hepy/app/modules/signup_photos/controller/signup_photos_controller.dart';

import '../controller/signin_controller.dart';

class SignInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}
