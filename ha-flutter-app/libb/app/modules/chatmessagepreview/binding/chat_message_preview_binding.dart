import 'package:get/get.dart';
import 'package:hepy/app/modules/chatmessagepreview/controller/chat_message_preview_controller.dart';

class ChatMessagePreviewBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ChatMessagePreviewController>(() => ChatMessagePreviewController());
  }

}