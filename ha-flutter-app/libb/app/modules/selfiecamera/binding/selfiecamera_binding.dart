import 'package:get/get.dart';
import 'package:hepy/app/modules/selfiecamera/controller/selfiecamera_controller.dart';

class SelfieCameraBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SelfieController>(() => SelfieController());
  }

}