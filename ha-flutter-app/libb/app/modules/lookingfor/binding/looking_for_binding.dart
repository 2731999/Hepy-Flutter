import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hepy/app/modules/lookingfor/controller/looking_for_controller.dart';

class LookingForBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LookingForController>(() => LookingForController());
  }
}
