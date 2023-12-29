import 'package:get/get.dart';
import 'package:hepy/app/modules/home/userdetails/controller/home_card_details_controller.dart';

class HomeCardDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeCardDetailsController>(() => HomeCardDetailsController());
  }
}
