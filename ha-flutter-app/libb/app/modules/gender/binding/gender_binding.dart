import 'package:get/get.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:hepy/app/modules/gender/controller/getnder_controller.dart';

class GenderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetxController>(() => GenderController());
  }
}
