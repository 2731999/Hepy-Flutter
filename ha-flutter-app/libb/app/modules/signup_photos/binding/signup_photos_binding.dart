import 'package:get/get.dart';
import 'package:hepy/app/modules/signup_photos/controller/signup_photos_controller.dart';

class SignupPhotosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupPhotosController>(() => SignupPhotosController());
  }
}
