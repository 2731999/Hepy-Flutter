import 'package:get/get.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/model/conversation/conversation_model.dart';
import 'package:hepy/app/model/conversation/conversations.dart';

class ChatMessagePreviewController extends GetxController{

  RxString otherUserImage = ''.obs;
  RxString otherUserName = ''.obs;

  String findOtherUserImage({required Conversations conversationModel}) {
    return otherUserImage.value =
    (CommonUtils().auth.currentUser!.uid == conversationModel.p1?.uid
        ? conversationModel.p2?.thumbUrl
        : conversationModel.p1?.thumbUrl)!;
  }

  String findOtherUserName({required Conversations conversationModel}) {
    return otherUserName.value =
    (CommonUtils().auth.currentUser!.uid == conversationModel.p1?.uid
        ? conversationModel.p2?.name
        : conversationModel.p1?.name)!;
  }

}