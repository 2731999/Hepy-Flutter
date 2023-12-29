import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/dialogs_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/conversation/conversation_model.dart';
import 'package:hepy/app/model/conversation/conversations.dart';
import 'package:hepy/app/modules/chat/controller/chat_controller.dart';
import 'package:hepy/app/modules/chatmessage/controller/chat_message_controller.dart';
import 'package:hepy/app/modules/home/view/home_view.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatMessageView extends GetView<ChatMessageController> {
  ChatMessageView({Key? key}) : super(key: key);
  ChatMessageController chatMessageController = ChatMessageController();

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "ChatMessageView date =====> ${CommonUtils().timestampToDate(Timestamp.now(), 'EEE, dd-MMM-yyyy')}");
    if (Get.arguments != null) {
      chatMessageController.conversationModel = Get.arguments[0];
    }
    if (Get.arguments != null && !chatMessageController.isFromNotification) {
      chatMessageController.isFromNotification = true;
    }
    chatMessageController.getConversation(
        conversationModel: chatMessageController.conversationModel,
        isAddTimeFilter: false);
    chatMessageController.findOtherUserId(
        conversationModel: chatMessageController.conversationModel);
    chatMessageController.findOtherUserImage(
        conversations: chatMessageController.conversationModel);
    chatMessageController.findOtherUserName(
        conversations: chatMessageController.conversationModel);
    chatMessageController.getConversationId();
    PreferenceUtils.isCurrentChatConversationScreen = true;
    return Obx(
      () => WillPopScope(
        onWillPop: () {
          PreferenceUtils.isCurrentChatConversationScreen = false;
          ChatController.isNeedToChatCallApi = true;
          if (chatMessageController.isFromNotification) {
            Get.offAndToNamed(Routes.DASHBOARD, arguments: [2, true]);
          } else {
            Get.back();
          }
          return Future<bool>.value(true);
        },
        child: Scaffold(
          appBar: WidgetHelper().chatMessageAppBr(
            userImage: chatMessageController.otherUserImage.value,
            userName: chatMessageController.otherUserName.value,
            isShowReportMenu: true,
            onReport: () {
              WidgetHelper().showBottomSheetDialog(
                  controller: userBlockDialogView(
                      context,
                      chatMessageController.conversationModel,
                      chatMessageController.otherUserName.value.capitalize!),
                  bottomSheetHeight: 0.0);
            },
            onBack: () {
              ChatController.isNeedToChatCallApi = true;
              PreferenceUtils.isCurrentChatConversationScreen = false;
              if (chatMessageController.isFromNotification) {
                Get.offAndToNamed(Routes.DASHBOARD, arguments: [2, true]);
              } else {
                Get.back();
              }
            },
          ),
          body: Container(
            color: AppColor.colorWhite.toColor(),
            height: Get.height,
            child: Column(
              children: [
                WidgetHelper().sizeBox(height: 16),
                WidgetHelper().simpleTextWithPrimaryColor(
                    textColor: AppColor.colorGray.toColor(),
                    text:
                        '${StringsNameUtils.matchedText.toUpperCase()} ${chatMessageController.findOtherUserName(conversations: chatMessageController.conversationModel).toUpperCase()} ${StringsNameUtils.onText.toUpperCase()} ${CommonUtils().timestampToDate(chatMessageController.conversationModel!.matchedAt!, 'dd-MMM-yyyy')}',
                    fontSize: 12),
                WidgetHelper().sizeBox(height: 16),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: chatMessageController.getChatMessage(
                                  conversationModel:
                                      chatMessageController.conversationModel),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                List<QueryDocumentSnapshot<Object?>> data = [];
                                List<QueryDocumentSnapshot<Object?>> temp = [];
                                if (PreferenceUtils.getStartModelData!
                                        .currentSubscriptionPlan!.plan!.id! ==
                                    1) {
                                  chatMessageController.senderSendCount = 0;
                                }
                                if (snapshot.hasData) {
                                  data = snapshot.data!.docs;
                                  // chatMessageController.conversationLength =
                                  //     data.length;
                                  for (QueryDocumentSnapshot<Object?> obj
                                      in data) {
                                    if (obj['sender'] ==
                                            PreferenceUtils
                                                .getStartModelData?.uid &&
                                        CommonUtils().timestampToDate(
                                                obj['createdAt'],
                                                'EEE, dd-MMM-yyyy') ==
                                            CommonUtils().timestampToDate(
                                                Timestamp.now(),
                                                'EEE, dd-MMM-yyyy')) {
                                      chatMessageController
                                          .conversationLength += 1;
                                    }
                                    if (obj['sender'] ==
                                            PreferenceUtils
                                                .getStartModelData?.uid &&
                                        obj['expiringAtForSender']
                                                .millisecondsSinceEpoch >=
                                            Timestamp.now()
                                                .millisecondsSinceEpoch) {
                                      temp.add(obj);
                                      if (PreferenceUtils
                                              .getStartModelData!
                                              .currentSubscriptionPlan!
                                              .plan!
                                              .id! ==
                                          1) {
                                        chatMessageController.senderSendCount =
                                            chatMessageController
                                                    .senderSendCount! +
                                                1;
                                      }
                                      debugPrint(
                                          "SenderCount ====> ${chatMessageController.senderSendCount}");
                                    } else if (obj['sender'] !=
                                            PreferenceUtils
                                                .getStartModelData?.uid &&
                                        obj['expiringAtForReceiver']
                                                .millisecondsSinceEpoch >=
                                            Timestamp.now()
                                                .millisecondsSinceEpoch) {
                                      if (obj['isSenderBlocked'] ?? false) {
                                      } else {
                                        temp.add(obj);
                                      }
                                    }
                                  }
                                  // var lstCards = temp.reversed.toList();
                                  data = temp;
                                }
                                Future.delayed(
                                    const Duration(milliseconds: 100), () {
                                  if (chatMessageController
                                      .scrollController.hasClients) {
                                    chatMessageController.scrollController
                                        .animateTo(
                                      chatMessageController.scrollController
                                          .position.maxScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeInQuad,
                                    );
                                  }
                                });
                                return ListView.builder(
                                    physics: const ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    reverse: false,
                                    controller:
                                        chatMessageController.scrollController,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      if (data[index].get('sender') ==
                                          CommonUtils().auth.currentUser?.uid) {
                                        dateSelection(data, index);
                                        senderBgDesign(data, index);
                                        if (index + 1 < data.length) {
                                          return senderItemView(
                                              messagesModel: data[index],
                                              isBothIdSame:
                                                  data[index].get('sender') !=
                                                      data[index + 1]
                                                          .get('sender'));
                                        } else {
                                          return senderItemView(
                                              messagesModel: data[index],
                                              isBothIdSame: true);
                                        }
                                      } else {
                                        dateSelection(data, index);
                                        receiverBgDesign(data, index);
                                        if (index + 1 < data.length) {
                                          return receiverItemView(
                                              messagesModel: data[index],
                                              isBothIdSame:
                                                  data[index].get('sender') !=
                                                      data[index + 1]
                                                          .get('sender'));
                                        } else {
                                          return receiverItemView(
                                              messagesModel: data[index],
                                              isBothIdSame: true);
                                        }
                                      }
                                    });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                chatMessageController.isUserBlock.value
                    ? Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: AppColor.colorGray.toColor(), width: 1),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: WidgetHelper().simpleTextWithPrimaryColor(
                                textColor: AppColor.colorText.toColor(),
                                text:
                                    "${StringsNameUtils.blockUser} ${chatMessageController.otherUserName}"),
                          ),
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 8, right: 8, bottom: 10),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            padding: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                  color: AppColor.colorGray.toColor(),
                                  width: 1),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () async {
                                      if (PreferenceUtils
                                              .getStartModelData
                                              ?.currentSubscriptionPlan
                                              ?.plan
                                              ?.id ==
                                          1) {
                                        if (chatMessageController
                                                .senderSendCount! <
                                            PreferenceUtils
                                                .getStartModelData!
                                                .currentSubscriptionPlan!
                                                .messagesPerMatch!) {
                                          WidgetHelper().showBottomSheetDialog(
                                              controller:
                                                  openCameraAndGallerySelectionDialog(
                                                      Get.context!,
                                                      chatMessageController
                                                          .conversationModel,
                                                      chatMessageController
                                                              .senderSendCount! +
                                                          1),
                                              bottomSheetHeight: 0.0);
                                        } else {
                                          HomeView homeView = HomeView();
                                          homeView.showSubscriptionDialog(
                                              Get.context!, false, true, true);
                                        }
                                      } else {
                                        WidgetHelper().showBottomSheetDialog(
                                            controller:
                                                openCameraAndGallerySelectionDialog(
                                                    Get.context!,
                                                    chatMessageController
                                                        .conversationModel,
                                                    chatMessageController
                                                        .senderSendCount!),
                                            bottomSheetHeight: 0.0);
                                      }
                                    },
                                    child: Image.asset(
                                      ImagePathUtils.camera_image,
                                      width: 30,
                                      height: 30,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 6,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: TextField(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        hintText: StringsNameUtils.typeMessage,
                                      ),
                                      minLines: 1,
                                      maxLines: 3,
                                      controller: chatMessageController
                                          .chatMessageEditText.value,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 0,
                                  child: InkWell(
                                    onTap: () async {
                                      if (chatMessageController
                                          .chatMessageEditText.value.text
                                          .trim()
                                          .isNotEmpty) {
                                        if (PreferenceUtils
                                                .getStartModelData
                                                ?.currentSubscriptionPlan
                                                ?.plan
                                                ?.id ==
                                            1) {
                                          if (chatMessageController
                                                  .senderSendCount! <
                                              PreferenceUtils
                                                  .getStartModelData!
                                                  .currentSubscriptionPlan!
                                                  .messagesPerMatch!) {
                                            chatMessageController.sendChatMessage(
                                                conversationModel:
                                                    chatMessageController
                                                        .conversationModel,
                                                messageType: 1,
                                                messageText:
                                                    chatMessageController
                                                        .chatMessageEditText
                                                        .value
                                                        .text,
                                                photoUrl: "",
                                                photoViewed: false,
                                                senderCount:
                                                    chatMessageController
                                                            .senderSendCount! +
                                                        1,
                                                timestamp: Timestamp.fromDate(
                                                    DateTime.now()));
                                          } else {
                                            HomeView homeView = HomeView();
                                            homeView.showSubscriptionDialog(
                                                context, false, true, true);
                                          }
                                        } else {
                                          chatMessageController.sendChatMessage(
                                              conversationModel:
                                                  chatMessageController
                                                      .conversationModel,
                                              messageType: 1,
                                              messageText: chatMessageController
                                                  .chatMessageEditText
                                                  .value
                                                  .text,
                                              photoUrl: "",
                                              photoViewed: false,
                                              senderCount: chatMessageController
                                                  .senderSendCount!,
                                              timestamp: Timestamp.fromDate(
                                                  DateTime.now()));
                                        }
                                        chatMessageController
                                            .chatMessageEditText.value
                                            .clear();
                                      }
                                    },
                                    child: WidgetHelper()
                                        .simpleTextWithPrimaryColor(
                                            textColor:
                                                AppColor.colorPrimary.toColor(),
                                            text: StringsNameUtils.send,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  dateSelection(List<QueryDocumentSnapshot<Object?>> data, int index) {
    if (index != 0 && index < data.length - 1) {
      chatMessageController.isShowDateView.value = false;
      if (chatMessageController.previousDate.isEmpty &&
          CommonUtils().timestampToDate(
                  data[index].get('createdAt'), 'EEE, dd-MMM-yyyy') !=
              CommonUtils().timestampToDate(
                  data[index - 1].get('createdAt'), 'EEE, dd-MMM-yyyy')) {
        chatMessageController.isShowDateView.value = true;
        chatMessageController.previousDate = "";
      } else if (chatMessageController.previousDate.isNotEmpty &&
          CommonUtils().timestampToDate(
                  data[index].get('createdAt'), 'EEE, dd-MMM-yyyy') !=
              CommonUtils().timestampToDate(
                  data[index - 1].get('createdAt'), 'EEE, dd-MMM-yyyy')) {
        chatMessageController.isShowDateView.value = true;
        chatMessageController.previousDate = "";
      } else {
        chatMessageController.isShowDateView.value = false;
        chatMessageController.previousDate = CommonUtils()
            .timestampToDate(data[index].get('createdAt'), 'EEE, dd-MMM-yyyy');
      }
    } else {
      if (index != 0 &&
          index == data.length - 1 &&
          CommonUtils().timestampToDate(
                  data[index].get('createdAt'), 'EEE, dd-MMM-yyyy') !=
              CommonUtils().timestampToDate(
                  data[index - 1].get('createdAt'), 'EEE, dd-MMM-yyyy')) {
        chatMessageController.isShowDateView.value = true;
        chatMessageController.previousDate = "";
      } else if (index == 0) {
        chatMessageController.isShowDateView.value = true;
        chatMessageController.previousDate = "";
      } else {
        chatMessageController.isShowDateView.value = false;
      }
    }
  }

  senderBgDesign(List<QueryDocumentSnapshot<Object?>> data, int index) {
    if (index == 0 ||
        chatMessageController.previousId != data[index].get('sender')) {
      if (index != 0 &&
          data[index - 1].get('sender') !=
              chatMessageController.otherUserUid.value) {
        chatMessageController.isLastSender.value = true;
      } else {
        chatMessageController.isFirstSender.value = false;
      }
    } else if (index + 1 < data.length &&
        (data[index + 1].get('sender') !=
            CommonUtils().auth.currentUser?.uid)) {
      chatMessageController.isLastSender.value = true;
    } else if (index + 1 < data.length &&
        (data[index - 1].get('sender') !=
            CommonUtils().auth.currentUser?.uid)) {
      chatMessageController.isFirstSender.value = false;
    } else if (index + 1 < data.length &&
        CommonUtils().timestampToDate(
                data[index].get('createdAt'), 'EEE, dd-MMM-yyyy') !=
            CommonUtils().timestampToDate(
                data[index + 1].get('createdAt'), 'EEE, dd-MMM-yyyy')) {
      chatMessageController.isLastSender.value = true;
    } else if (index + 1 == data.length) {
      chatMessageController.isLastSender.value = true;
      chatMessageController.isFirstSender.value = false;
    }
    chatMessageController.previousId = data[index].get('sender');
  }

  receiverBgDesign(List<QueryDocumentSnapshot<Object?>> data, int index) {
    if (index == 0 ||
        chatMessageController.previousId != data[index].get('sender')) {
      if (index != 0 &&
          index + 1 < data.length &&
          data[index - 1].get('sender') ==
              chatMessageController.otherUserUid.value) {
        chatMessageController.isLastReceiver.value = true;
      } else {
        chatMessageController.isFirstReceiver.value = false;
      }
    } else if (index + 1 < data.length &&
        data[index + 1].get('sender') !=
            chatMessageController.otherUserUid.value) {
      chatMessageController.isLastReceiver.value = true;
      // chatMessageController.isLastSender.value = false;
    } else if (index + 1 < data.length &&
        CommonUtils().timestampToDate(
                data[index].get('createdAt'), 'EEE, dd-MMM-yyyy') !=
            CommonUtils().timestampToDate(
                data[index + 1].get('createdAt'), 'EEE, dd-MMM-yyyy')) {
      chatMessageController.isLastReceiver.value = true;
    } else if (index + 1 < data.length &&
        data[index - 1].get('sender') !=
            chatMessageController.otherUserUid.value) {
      chatMessageController.isFirstReceiver.value = false;
    } else if (index + 1 == data.length) {
      chatMessageController.isLastReceiver.value = true;
    }
    chatMessageController.previousId = data[index].get('sender');
  }

  senderItemView(
      {required QueryDocumentSnapshot<Object?> messagesModel,
      required isBothIdSame}) {
    if (chatMessageController.previousDate ==
        CommonUtils()
            .timestampToDate(messagesModel['createdAt'], 'EEE, dd-MMM-yyyy')) {
      chatMessageController.isShowDateView.value = false;
    }
    if (chatMessageController.isShowDateView.value) {
      chatMessageController.isFirstSender.value = false;
      // chatMessageController.isLastSender.value = false;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (chatMessageController.isShowDateView.value)
          WidgetHelper().sizeBox(height: 5),
        if (chatMessageController.isShowDateView.value)
          Center(
            child: WidgetHelper().simpleTextWithPrimaryColor(
                textColor: AppColor.colorGray.toColor(),
                text: CommonUtils().timestampToDate(
                    messagesModel['createdAt'], 'EEE, dd-MMM-yyyy'),
                fontSize: 12),
          ),
        if (chatMessageController.isShowDateView.value)
          WidgetHelper().sizeBox(height: 5),
        Container(
          width: Get.width / 1.5,
          margin: const EdgeInsets.only(left: 70),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 3),
                  decoration: chatMessageController.getSenderViewIndex(
                              isUpdate: false, isBothSame: isBothIdSame)[0] ==
                          0
                      ? chatMessageController.senderLastItemDecoration()
                      : chatMessageController.getSenderViewIndex(
                                  isUpdate: true,
                                  isBothSame: isBothIdSame)[0] ==
                              2
                          ? chatMessageController.senderFirstItemDecoration()
                          : chatMessageController.senderSecondItemDecoration(),
                  child: messagesModel.get('messageType') == 1
                      ? Container(
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, top: 3, bottom: 3),
                          child: Text(
                            messagesModel.get('content')['text'],
                            style: TextStyle(
                                color: AppColor.colorWhite.toColor(),
                                fontSize: 16),
                          ),
                        )
                      : Container(
                          margin: const EdgeInsets.only(
                              left: 5, right: 5, top: 3, bottom: 3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                ImagePathUtils.photo_image,
                                width: 24,
                                height: 24,
                                color: AppColor.colorWhite.toColor(),
                              ),
                              WidgetHelper().sizeBox(width: 5),
                              Text(
                                messagesModel.get('content')['text'],
                                style: TextStyle(
                                    color: AppColor.colorWhite.toColor(),
                                    fontStyle: FontStyle.italic,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
        if (chatMessageController.isShowTime.value)
          Container(
            width: Get.width / 1.5,
            margin: const EdgeInsets.only(top: 5, right: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                      textColor: AppColor.colorGray.toColor(),
                      text: CommonUtils().timestampToDate(
                          messagesModel['createdAt'], 'hh:mm a'),
                      fontSize: 12),
                )
              ],
            ),
          )
      ],
    );
  }

  receiverItemView(
      {required QueryDocumentSnapshot<Object?> messagesModel,
      required isBothIdSame}) {
    if (!messagesModel["isSenderBlocked"] &&
        messagesModel['receiver'] == CommonUtils().auth.currentUser?.uid) {
      if (chatMessageController.previousDate ==
          CommonUtils().timestampToDate(
              messagesModel['createdAt'], 'EEE, dd-MMM-yyyy')) {
        chatMessageController.isShowDateView.value = false;
      }
      if (chatMessageController.isShowDateView.value) {
        chatMessageController.isFirstReceiver.value = false;
        chatMessageController.isLastReceiver.value = false;
      }
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (chatMessageController.isShowDateView.value)
            Center(
              child: WidgetHelper().simpleTextWithPrimaryColor(
                  textColor: AppColor.colorGray.toColor(),
                  text: CommonUtils().timestampToDate(
                      messagesModel['createdAt'], 'EEE, dd-MMM-yyyy'),
                  fontSize: 12),
            ),
          if (chatMessageController.isShowDateView.value)
            WidgetHelper().sizeBox(height: 10),
          Container(
            width: Get.width / 1.5,
            margin: const EdgeInsets.only(right: 70),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (!chatMessageController.isFirstReceiver.value)
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColor.colorWhite.toColor(), width: 1),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    chatMessageController.otherUserImage.value),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          margin: chatMessageController.isFirstReceiver.value
                              ? const EdgeInsets.only(
                                  left: 47, right: 5, top: 4)
                              : const EdgeInsets.only(
                                  left: 5, right: 5, top: 4),
                          decoration:
                              chatMessageController.getReceiverViewIndex(
                                          isUpdate: false,
                                          isBothSame: isBothIdSame)[0] ==
                                      0
                                  ? chatMessageController
                                      .receiverLastItemDecoration()
                                  : chatMessageController.getReceiverViewIndex(
                                              isUpdate: true,
                                              isBothSame: isBothIdSame)[0] ==
                                          2
                                      ? chatMessageController
                                          .receiverFirstItemDecoration()
                                      : chatMessageController
                                          .receiverSecondItemDecoration(),
                          child: messagesModel.get('messageType') == 1
                              ? Container(
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 5, top: 3, bottom: 3),
                                  child: Text(
                                    messagesModel.get('content')['text'],
                                    style: TextStyle(
                                        color: AppColor.colorText.toColor(),
                                        fontSize: 16),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    if (messagesModel.get('messageType') == 2 &&
                                        !messagesModel
                                            .get('content')['photoViewed']) {
                                      chatMessageController
                                          .changePhotoViewedValueAfterShowPhoto(
                                              conversationId:
                                                  chatMessageController
                                                      .conversationModel!.id!,
                                              messageId: messagesModel.id);
                                      Get.toNamed(Routes.CHAT_MESSAGE_PREVIEW,
                                          arguments: [
                                            chatMessageController
                                                .conversationModel,
                                            messagesModel
                                                .get('content')['photo']
                                          ]);
                                    }
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        left: 5, right: 5, top: 3, bottom: 3),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        messagesModel.get('content')['text'] ==
                                                "Opened"
                                            ? Image.asset(
                                                ImagePathUtils.photo_image,
                                                width: 24,
                                                height: 24,
                                                color: AppColor.colorGray
                                                    .toColor(),
                                              )
                                            : Image.asset(
                                                ImagePathUtils.photo_image,
                                                width: 24,
                                                height: 24,
                                              ),
                                        WidgetHelper().sizeBox(width: 5),
                                        Text(
                                          messagesModel.get('content')['text'],
                                          style: TextStyle(
                                              color: messagesModel.get(
                                                          'content')['text'] ==
                                                      "Opened"
                                                  ? AppColor.colorGray.toColor()
                                                  : AppColor.colorText
                                                      .toColor(),
                                              fontStyle: FontStyle.italic,
                                              fontSize: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (chatMessageController.isReceiverShowTime.value)
            Container(
              width: Get.width / 1.5,
              margin: const EdgeInsets.only(top: 5, left: 47),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: WidgetHelper().simpleTextWithPrimaryColor(
                        textColor: AppColor.colorGray.toColor(),
                        text: CommonUtils().timestampToDate(
                            messagesModel['createdAt'], 'hh:mm a'),
                        fontSize: 12),
                  )
                ],
              ),
            )
        ],
      );
    } else {
      return Container();
    }
  }

  Widget userBlockDialogView(
      BuildContext context, Conversations? conversationModel, String name) {
    chatMessageController
        .checkUseIsReported(conversationId: conversationModel!.id!)
        .then((value) {
      chatMessageController.isUserReport.value = value;
    });
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 48, right: 20, left: 20),
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: () {
                  if (!chatMessageController.isUserReport.value) {
                    if (!chatMessageController.isUserBlock.value) {
                      Get.back();
                      DialogsUtils.commonDialog(
                          context: context,
                          image: "",
                          onCancel: () {
                            // Get.back();
                            chatMessageController.userReport(
                                conversationModel,
                                !chatMessageController.isUserReport.value,
                                false);
                          },
                          onOk: () {
                            chatMessageController.userReport(
                                conversationModel,
                                !chatMessageController.isUserReport.value,
                                true);
                          },
                          title:
                              "${StringsNameUtils.reporting} ${chatMessageController.otherUserName.toUpperCase()}",
                          msg: StringsNameUtils.blockUserMessage);
                    } else {
                      chatMessageController.userReport(conversationModel,
                          !chatMessageController.isUserReport.value, false);
                    }
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: chatMessageController.isUserReport.value
                            ? AppColor.colorGray.toColor()
                            : AppColor.colorPrimary.toColor(),
                        width: 2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          width: 20,
                          height: 20,
                          ImagePathUtils.flag_image,
                          fit: BoxFit.contain,
                          color: chatMessageController.isUserReport.value
                              ? AppColor.colorGray.toColor()
                              : AppColor.colorPrimary.toColor(),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              chatMessageController.isUserReport.value
                                  ? "${StringsNameUtils.reported} ${name.toUpperCase()}"
                                  : "${StringsNameUtils.report} ${name.toUpperCase()}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: chatMessageController.isUserReport.value
                                    ? AppColor.colorGray.toColor()
                                    : AppColor.colorPrimary.toColor(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: InkWell(
                onTap: () {
                  chatMessageController.userBlock(conversationModel,
                      !chatMessageController.isUserBlock.value);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.colorPrimary.toColor(), width: 2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        Image.asset(
                          width: 20,
                          height: 20,
                          ImagePathUtils.block_image,
                          fit: BoxFit.contain,
                          color: AppColor.colorPrimary.toColor(),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              chatMessageController.isUserBlock.value
                                  ? "${StringsNameUtils.unblock} ${name.toUpperCase()}"
                                  : "${StringsNameUtils.block} ${name.toUpperCase()}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.colorPrimary.toColor()),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                  chatMessageController.unMatchApiCall(
                      unMatchUserId: chatMessageController.otherUserUid.value);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.colorPrimary.toColor(), width: 2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Center(
                      child: Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      Image.asset(
                        width: 25,
                        height: 25,
                        ImagePathUtils.unMatch_image,
                        fit: BoxFit.contain,
                        color: AppColor.colorPrimary.toColor(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "${StringsNameUtils.unMatch} ${name.toUpperCase()}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColor.colorPrimary.toColor()),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                    ],
                  )),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 50,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.colorGray.toColor(), width: 2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      StringsNameUtils.close,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColor.colorGray.toColor()),
                    ),
                  ),
                ),
              ),
            ),
            WidgetHelper().sizeBox(height: 20),
          ],
        ),
      ),
    );
  }

  openCameraAndGallerySelectionDialog(BuildContext context,
      Conversations? conversationModel, int senderCount) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: WidgetHelper().commonPaddingOrMargin(),
      margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
      child: Column(
        children: [
          WidgetHelper()
              .titleTextView(titleText: StringsNameUtils.selectPhotos),
          WidgetHelper().sizeBox(height: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  Get.back();
                  var value = await Get.toNamed(Routes.SELFIE_CAMERA);
                  chatMessageController.openCamera(
                      imagePath: value[0],
                      conversationModel: conversationModel,
                      senderCount: senderCount);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: WidgetHelper().simpleTextWithPrimaryColor(
                        text: StringsNameUtils.camera,
                        textColor: AppColor.colorText.toColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              WidgetHelper().sizeBox(height: 5),
              Divider(
                color: AppColor.colorGray.toColor(),
              ),
              WidgetHelper().sizeBox(height: 10),
              InkWell(
                onTap: () {
                  chatMessageController.openGallery(
                      conversationModel: conversationModel,
                      senderCount: senderCount);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: WidgetHelper().simpleTextWithPrimaryColor(
                        text: StringsNameUtils.gallery,
                        textColor: AppColor.colorText.toColor(),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              WidgetHelper().sizeBox(height: 5),
              Divider(
                color: AppColor.colorGray.toColor(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
