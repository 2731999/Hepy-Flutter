import 'package:get/get.dart';
import 'package:hepy/app/modules/aboutme/controller/about_me_controller.dart';

class AboutMeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AboutMeController>(() => AboutMeController());
  }
}
