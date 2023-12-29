import 'package:get/get.dart';
import 'package:hepy/app/modules/banned/controller/banned_view_controller.dart';

class BannedViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BannedViewController>(() => BannedViewController());
  }
}
