import 'package:get/get.dart';

import '../controller/webview_controller.dart';

class CommonWebViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewController>(() => WebviewController());
  }
}
