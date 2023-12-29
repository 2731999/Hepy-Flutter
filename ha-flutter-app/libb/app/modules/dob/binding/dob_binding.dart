import 'package:get/get.dart';
import 'package:hepy/app/modules/dob/controller/dob_controller.dart';

class DobBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DobController>(() => DobController());
  }
}
