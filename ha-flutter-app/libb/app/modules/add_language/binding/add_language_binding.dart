import 'package:get/get.dart';
import 'package:hepy/app/modules/add_language/controller/add_language_controller.dart';

class AddLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLanguageController>(() => AddLanguageController());
  }
}
