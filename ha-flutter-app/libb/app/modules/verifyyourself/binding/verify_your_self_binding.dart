import 'package:get/get.dart';
import 'package:hepy/app/modules/verifyyourself/controller/verify_your_self_controller.dart';

class VerifyYourSelfBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<VerifyYourSelfController>(() => VerifyYourSelfController());
  }

}