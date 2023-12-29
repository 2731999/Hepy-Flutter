import 'package:get/get.dart';
import 'package:hepy/app/modules/qod/controller/qod_controller.dart';

class QODBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QODController>(() => QODController());
  }
}
