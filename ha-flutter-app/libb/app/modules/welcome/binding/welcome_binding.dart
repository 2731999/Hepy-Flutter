import 'package:get/get_instance/get_instance.dart';
import 'package:get/utils.dart';

import '../controller/welcome_controller.dart';

class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WelcomeController>(
      () => WelcomeController(),
    );
  }
}
