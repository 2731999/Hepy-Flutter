import 'package:get/get.dart';
import 'package:hepy/app/modules/chatmessage/controller/chat_message_controller.dart';

class ChatMessageBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ChatMessageController>(() => ChatMessageController());
  }
}
