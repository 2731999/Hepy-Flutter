import 'package:get/get.dart';

import '../../add_more_photos/controller/add_more_photos_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddMorePhotosController>(() => AddMorePhotosController());
  }
}
