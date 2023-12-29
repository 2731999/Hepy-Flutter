import 'package:get/get.dart';
import 'package:hepy/app/modules/add_more_photos/controller/add_more_photos_controller.dart';

class AddMorePhotosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMorePhotosController>(() => AddMorePhotosController());
  }
}
