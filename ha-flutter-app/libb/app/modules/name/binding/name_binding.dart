import 'package:get/get.dart';
import 'package:hepy/app/modules/name/contoller/name_controller.dart';

class NameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NameController>(() => NameController());
  }
}
