import 'package:get/get.dart';
import 'package:hepy/app/modules/email/controller/email_controller.dart';

class EmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailController>(() => EmailController());
  }
}
