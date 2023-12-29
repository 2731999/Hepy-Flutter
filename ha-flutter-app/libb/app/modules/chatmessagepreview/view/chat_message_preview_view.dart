import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/model/conversation/conversation_model.dart';
import 'package:hepy/app/model/conversation/conversations.dart';
import 'package:hepy/app/modules/chatmessagepreview/controller/chat_message_preview_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class ChatMessagePreviewView extends GetView<ChatMessagePreviewController> {
  ChatMessagePreviewView({Key? key}) : super(key: key);
  ChatMessagePreviewController chatMessagePreviewController =
      ChatMessagePreviewController();
  Conversations conversationModel = Get.arguments[0];

  @override
  Widget build(BuildContext context) {
    chatMessagePreviewController.findOtherUserImage(
        conversationModel: conversationModel);
    chatMessagePreviewController.findOtherUserName(
        conversationModel: conversationModel);

    return WillPopScope(
      onWillPop: () {
        Get.back();
        return Future<bool>.value(true);
      },
      child: Scaffold(
        appBar: WidgetHelper().chatMessageAppBr(
          userImage: chatMessagePreviewController.otherUserImage.value,
          userName: chatMessagePreviewController.otherUserName.value,
          onBack: () {
            Get.back();
          },
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Image.network(
            Get.arguments[1],
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.height,
          ),
        ),
      ),
    );
  }
}
