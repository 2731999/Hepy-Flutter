import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/chat/controller/chat_controller.dart';
import 'package:hepy/app/modules/chatmessage/controller/chat_message_controller.dart';
import 'package:hepy/app/modules/like/controller/like_controller.dart';
import 'package:hepy/app/notification/notification.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class ChatView extends StatefulWidget {
  ChatView({Key? key}) : super(key: key);
  //todo temp change
  ChatController chatController = ChatController();
  ChatMessageController chatMessageController = ChatMessageController();

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  String notificationBody = 'No Data';

  _changeBody(String msg) => setState(() => notificationBody = msg);

  @override
  void initState() {
    super.initState();
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
  }
  //todo add swipe refresh
  @override
  Widget build(BuildContext context) {
    if(ChatController.isNeedToChatCallApi){
      widget.chatController.getAllLikedUsers();
      ChatController.isNeedToChatCallApi = false;
    }
    return Obx(
      () => widget.chatController.isLoader.value
          ? Container(
              color: AppColor.colorWhite.toColor(),
              child: const Center(child: CircularProgressIndicator()),
            )
          : Scaffold(
              body: RefreshIndicator(
                onRefresh: () => widget.chatController.getAllLikedUsers(),
                child: Container(
                  color: AppColor.colorWhite.toColor(),
                  margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 7),
                        child: WidgetHelper().simpleTextWithPrimaryColor(
                            textColor: AppColor.colorText.toColor(),
                            text: StringsNameUtils.yourMatches,
                            fontSize: 24,
                            fontWeight: FontWeight.w700),
                      ),
                      WidgetHelper().sizeBox(height: 16),
                      SizedBox(
                        height: 80,
                        child: matchesView(),
                      ),
                      WidgetHelper().sizeBox(height: 24),
                      Divider(
                        color: AppColor.colorGray.toColor(),
                      ),
                      WidgetHelper().sizeBox(height: 24),
                      Expanded(
                        child: conversationView(),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  matchesView() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: (){
            LikeController.isNeedToCallApi = true;
            Get.offAndToNamed(Routes.DASHBOARD, arguments: [1, true]);
          },
          child: Container(
            width: 70,
            height: 70,
            margin: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppColor.colorPrimary.toColor(),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: WidgetHelper().simpleTextWithPrimaryColor(
                  textColor: AppColor.colorWhite.toColor(),
                  text: widget.chatController.likedCount.value > 100
                      ? StringsNameUtils.likedCount
                      : '${widget.chatController.likedCount.value}\nliked',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center),
            ),
          ),
        ),
        widget.chatController.lstUsersMatch.value.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                  //todo change scroll type
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.chatController.lstUsersMatch.value.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () async {
                        await Get.toNamed(Routes.CHAT_MESSAGE_SCREEN,
                            arguments: [
                              widget.chatController.lstUsersMatch[index]
                            ]);
                        widget.chatController.getAllLikedUsers();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(7),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColor.colorPrimary.toColor(), width: 2),
                        ),
                        child: CommonUtils().auth.currentUser!.uid ==
                                widget.chatController.lstUsersMatch.value[index]
                                    .p1?.uid
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(widget
                                              .chatController
                                              .lstUsersMatch
                                              .value[index]
                                              .p2
                                              ?.thumbUrl ??
                                          ''),
                                      fit: BoxFit.cover),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(widget
                                              .chatController
                                              .lstUsersMatch
                                              .value[index]
                                              .p1
                                              ?.thumbUrl ??
                                          ''),
                                      fit: BoxFit.cover),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  conversationView() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 7),
          child: WidgetHelper().simpleTextWithPrimaryColor(
              textColor: AppColor.colorText.toColor(),
              text: StringsNameUtils.conversation,
              fontSize: 24,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w700),
        ),
        WidgetHelper().sizeBox(height: 16),
        widget.chatController.lstConversation.value.isNotEmpty
            ? Expanded(
          child: ListView.builder(
            //todo change scroll type
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.chatController.lstConversation.value.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  await Get.toNamed(Routes.CHAT_MESSAGE_SCREEN,
                      arguments: [
                        widget.chatController.lstConversation[index]
                      ]);
                  widget.chatController.getAllLikedUsers();
                },
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 12, top: 12, bottom: 12),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColor.colorPrimary.toColor(),
                            width: 2),
                      ),
                      child: Center(
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(widget
                                    .chatMessageController
                                    .findOtherUserImage(
                                    conversations: widget
                                        .chatController
                                        .lstConversation[index])),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    WidgetHelper().sizeBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 5, bottom: 2.5),
                            child: WidgetHelper()
                                .simpleTextWithPrimaryColor(
                                textColor:
                                AppColor.colorText.toColor(),
                                text: widget.chatMessageController
                                    .findOtherUserName(
                                    conversations: widget
                                        .chatController
                                        .lstConversation[index]),
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                          if (widget.chatController.lstConversation[index]
                              .lastMessage!.isSenderBlocked! &&
                              widget.chatController.lstConversation[index]
                                  .lastMessage?.sender ==
                                  CommonUtils().auth.currentUser?.uid)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.5, bottom: 5),
                              child: WidgetHelper()
                                  .simpleTextWithPrimaryColor(
                                  textColor:
                                  AppColor.colorText.toColor(),
                                  text: widget
                                      .chatController
                                      .lstConversation[index]
                                      .lastMessage
                                      ?.content,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          if (!widget
                              .chatController
                              .lstConversation[index]
                              .lastMessage!
                              .isSenderBlocked!)
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 2.5, bottom: 5),
                              child: WidgetHelper()
                                  .simpleTextWithPrimaryColor(
                                  textColor:
                                  AppColor.colorText.toColor(),
                                  text: widget
                                      .chatController
                                      .lstConversation[index]
                                      .lastMessage
                                      ?.content,
                                  fontSize: 16,
                                  overflow: TextOverflow.ellipsis),
                            )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        )
            : Container()
      ],
    );
  }
}
