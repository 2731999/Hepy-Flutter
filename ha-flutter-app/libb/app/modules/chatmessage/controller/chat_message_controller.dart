import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/conversation/conversation_model.dart';
import 'package:hepy/app/model/conversation/conversations.dart';
import 'package:hepy/app/model/conversation/last_message_model.dart';
import 'package:hepy/app/model/conversation/messages_model.dart';
import 'package:hepy/app/model/conversation/un_match_model.dart';
import 'package:hepy/app/model/report/report_model.dart';
import 'package:hepy/app/model/uploadphoto/user_upload_photo_model.dart';
import 'package:hepy/app/modules/home/view/home_view.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class ChatMessageController extends GetxController {
  Rx<TextEditingController> chatMessageEditText = TextEditingController().obs;
  RxString otherUserUid = ''.obs;
  RxString otherUserImage = ''.obs;
  RxString otherUserName = ''.obs;
  RxString otherUser = ''.obs;
  Timestamp? senderExpiryTime;
  Timestamp? receiverExpiryTime;
  ScrollController scrollController = ScrollController();
  RxList<MessagesModel> lstMessage = <MessagesModel>[].obs;
  RxBool isUserBlock = false.obs;
  RxBool isUserReport = false.obs;
  RxBool isFirstSender = false.obs;
  RxBool isLastSender = false.obs;
  RxBool isFirstReceiver = false.obs;
  RxBool isLastReceiver = false.obs;
  String previousDate = '';
  String previousId = '';
  String? currentId = '';
  RxBool isShowDateView = false.obs;
  RxBool isShowTime = false.obs;
  RxBool isReceiverShowTime = false.obs;
  bool isFromNotification = false;
  int conversationLength = 0;
  Conversations? conversationModel;
  int? senderSendCount = 0;

  RxBool isSender = false.obs;
  int continueConversation = -1;

  void findOtherUserId({required Conversations? conversationModel}) async {
    otherUserUid.value =
        (CommonUtils().auth.currentUser!.uid == conversationModel?.p1?.uid
            ? conversationModel?.p2?.uid
            : conversationModel?.p1?.uid)!;

    await updateConversationAfterBlockedUser(isGoBack: false);

    conversationModel = this.conversationModel;

    isUserBlock.value =
        (CommonUtils().auth.currentUser!.uid == conversationModel?.p1?.uid
                ? conversationModel?.p2?.isBlocked
                : conversationModel?.p1?.isBlocked) ??
            false;

    otherUser.value =
        (CommonUtils().auth.currentUser!.uid == conversationModel?.p1?.uid
            ? "p2" // Self user
            : "p1"); // Other user
  }

  String findOtherUserImage({required Conversations? conversations}) {
    return otherUserImage.value =
        (CommonUtils().auth.currentUser!.uid == conversations?.p1?.uid
            ? conversations?.p2?.thumbUrl
            : conversations?.p1?.thumbUrl)!;
  }

  String findOtherUserName({required Conversations? conversations}) {
    return otherUserName.value =
        (CommonUtils().auth.currentUser!.uid == conversations?.p1?.uid
            ? conversations?.p2?.name
            : conversations?.p1?.name)!;
  }

  void scrollDown() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

   void getConversationId(){
    PreferenceUtils.conversationId = conversationModel?.id;
  }

  /// This method is add sender data into db
  /// when user send any message or images it will create
  /// new sub collection with "Messages" and all conversation
  /// is saved in this collection
  void sendChatMessage(
      {required Conversations? conversationModel,
      required int messageType,
      required messageText,
      required photoUrl,
      required bool photoViewed,
      required Timestamp timestamp,
      required int senderCount}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    isFirstSender.value = false;
    isLastSender.value = false;
    isFirstReceiver.value = false;
    isLastReceiver.value = false;

    await setSenderAndReceiverExpiryDateAccordingRetentionPolicy(
        uid: CommonUtils().auth.currentUser?.uid, isSender: true);
    await setSenderAndReceiverExpiryDateAccordingRetentionPolicy(
        uid: otherUserUid.value, isSender: false);

    Map<String, dynamic> content = {
      'text': messageText,
      'photo': photoUrl,
      'photoViewed': photoViewed,
    };

    await updateConversationAfterBlockedUser();
    conversationModel = this.conversationModel;
    late bool isUserBlocked;
    if (conversationModel?.p1?.uid == CommonUtils().auth.currentUser?.uid) {
      isUserBlocked = conversationModel!.p1!.isBlocked!;
    } else if (conversationModel?.p2?.uid ==
        CommonUtils().auth.currentUser?.uid) {
      isUserBlocked = conversationModel!.p2!.isBlocked!;
    }

    Map<String, dynamic> messages = {
      'sender': CommonUtils().auth.currentUser?.uid,
      'receiver': otherUserUid.value,
      'messageType': messageType,
      'content': content,
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'expiringAtForSender': senderExpiryTime,
      'expiringAtForReceiver': receiverExpiryTime,
      'isSenderBlocked': isUserBlocked,
    };

    Map<String, dynamic> lastMessage = {
      'sender': CommonUtils().auth.currentUser?.uid,
      'receiver': otherUserUid.value,
      'messageType': messageType,
      'content': messageText.toString().isEmpty ? photoUrl : messageText,
      'isSenderBlocked': isUserBlocked,
      'createdAt': Timestamp.fromDate(DateTime.now()),
      'expiringAtForSender': senderExpiryTime,
      'expiringAtForReceiver': receiverExpiryTime,
    };

    conversationModel?.lastMessage =
        LastMessageModel.fromJson(lastMessage);

    debugPrint("Conversation Id ===> ${conversationModel?.id}");

    await firebaseFirestore
        .collection(StringsNameUtils.tblConversation)
        .doc(conversationModel?.id)
        .set(conversationModel!.toJson(), SetOptions(merge: true))
        .then((value) async {
      await firebaseFirestore
          .collection(StringsNameUtils.tblConversation)
          .doc(conversationModel?.id)
          .collection(StringsNameUtils.tblMessages)
          .add(MessagesModel.fromJson(messages).toJson())
          .then((value) {
        getChatMessage(conversationModel: conversationModel);
        if (!isUserBlocked) {
          sendMessageNotification(
              conversationId: conversationModel?.id, messageId: value.id);
        }
      });
    });
  }

  /// This method is get chat conversation and update data
  void getConversation(
      {required Conversations? conversationModel,
      required isAddTimeFilter,
      Timestamp? timestamp}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    if (isAddTimeFilter) {
      await firebaseFirestore
          .collection(StringsNameUtils.tblConversation)
          .doc(conversationModel?.id)
          .collection(StringsNameUtils.tblMessages)
          .where('createdAt', isGreaterThan: timestamp)
          .orderBy('createdAt')
          .get()
          .then((value) {
        List.of(value.docs.map((conversation) {
          lstMessage.add(MessagesModel.fromJson(conversation.data()));
        }));
        lstMessage.refresh();
      });
    } else {
      lstMessage.clear();
      await firebaseFirestore
          .collection(StringsNameUtils.tblConversation)
          .doc(conversationModel?.id)
          .collection(StringsNameUtils.tblMessages)
          .orderBy('createdAt')
          .get()
          .then((value) {
        List.of(value.docs.map((conversation) {
          MessagesModel messagesModel =
              MessagesModel.fromJson(conversation.data());
          if (messagesModel.expiringAtForSender!.millisecondsSinceEpoch >
                  Timestamp.now().millisecondsSinceEpoch &&
              messagesModel.expiringAtForReceiver!.millisecondsSinceEpoch >
                  Timestamp.now().millisecondsSinceEpoch) {
            lstMessage.add(messagesModel);
          }
        }));
        lstMessage.refresh();
      });
    }
  }

  changePhotoViewedValueAfterShowPhoto(
      {required String conversationId, required String messageId}) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection(StringsNameUtils.tblConversation)
        .doc(conversationId)
        .collection(StringsNameUtils.tblMessages)
        .doc(messageId)
        .update({'content.photoViewed': true, 'content.text': 'Opened'});
  }

  /// This method is set sender expiry time based on their current plan
  /// if plan is standard or gold the expiry time is 24h.
  /// if plan is platinum, user can choose retention policy like 24h, 1 week, never by default is 24h
  Future<void> setSenderAndReceiverExpiryDateAccordingRetentionPolicy(
      {required String? uid, required isSender}) async {
    int? planId = await UserTbl().getPlanIdByUid(uid!);
    switch (planId) {
      case 1:
      case 2:
        if (isSender) {
          senderExpiryTime =
              Timestamp.fromDate(DateTime.now().add(const Duration(hours: 24)));
        } else {
          receiverExpiryTime =
              Timestamp.fromDate(DateTime.now().add(const Duration(hours: 24)));
        }
        break;
      case 3:
        UserTbl userTbl = UserTbl();
        await userTbl.getCurrentUserMessageDisappearByUid(uid!).then((value) {
          switch (value) {
            case '24h':
              if (isSender) {
                senderExpiryTime = Timestamp.fromDate(
                    DateTime.now().add(const Duration(hours: 24)));
              } else {
                receiverExpiryTime = Timestamp.fromDate(
                    DateTime.now().add(const Duration(hours: 24)));
              }
              break;
            case '1 Week':
              if (isSender) {
                senderExpiryTime = Timestamp.fromDate(
                    DateTime.now().add(const Duration(days: 7)));
              } else {
                receiverExpiryTime = Timestamp.fromDate(
                    DateTime.now().add(const Duration(days: 7)));
              }
              break;
            case 'Never':
              DateTime dateTime = DateTime(2099, 12, 31, 23, 59, 59);
              if (isSender) {
                senderExpiryTime = Timestamp.fromDate(dateTime);
              } else {
                receiverExpiryTime = Timestamp.fromDate(dateTime);
              }
              break;
          }
        });
        break;
    }
  }

  Stream<QuerySnapshot> getChatMessage(
      {required Conversations? conversationModel}) {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    return firebaseFirestore
        .collection(StringsNameUtils.tblConversation)
        .doc(conversationModel?.id)
        .collection(StringsNameUtils.tblMessages)
        .orderBy('createdAt')
        .snapshots();
  }

  Future<void> userBlock(
      Conversations? conversationModel, bool isBlocked) async {
    Timestamp blockedAt = Timestamp.fromDate(DateTime.now());
    FirebaseFirestore.instance
        .collection(StringsNameUtils.tblConversation)
        .doc(conversationModel?.id)
        .update({
      '${otherUser.value}.isBlocked': isBlocked,
      '${otherUser.value}.blockedAt': blockedAt,
    }).then(
      (_) {
        isUserBlock.value = isBlocked;
        updateConversationAfterBlockedUser(isGoBack: true);
      },
    ).catchError((error) => print('userBlock p1Failed: $error'));
  }

  Future<void> updateConversationAfterBlockedUser(
      {bool isGoBack = false}) async {
    await FirebaseFirestore.instance
        .collection(StringsNameUtils.tblConversation)
        .doc(conversationModel?.id)
        .get()
        .then((updatedConversationModel) {
      conversationModel = Conversations.fromJson(updatedConversationModel.data()!);
      debugPrint(
          "blocked unBlocked conversation model ====> ${updatedConversationModel.data()}");
      if (isGoBack) {
        Get.back();
      }
    });
  }

  Future<void> userReport(Conversations conversationModel, bool isReport,
      bool isAlsoBlocked) async {
    String? reportedByUid = "";
    String? reportedByName = "";
    String? reportedByThumbUrl = "";

    String? reportedUid = "";
    String? reportedName = "";
    String? reportedThumbUrl = "";
    if (CommonUtils().auth.currentUser!.uid != conversationModel.p1?.uid) {
      ///other user
      reportedByUid = conversationModel.p2!.uid;
      reportedByName = conversationModel.p2!.name;
      reportedByThumbUrl = conversationModel.p2!.thumbUrl;
    }
    if (CommonUtils().auth.currentUser!.uid != conversationModel.p2?.uid) {
      ///other user
      reportedByUid = conversationModel.p1!.uid;
      reportedByName = conversationModel.p1!.name;
      reportedByThumbUrl = conversationModel.p1!.thumbUrl;
    }

    if (CommonUtils().auth.currentUser!.uid == conversationModel.p1?.uid) {
      ///self user
      reportedUid = conversationModel.p2!.uid;
      reportedName = conversationModel.p2!.name;
      reportedThumbUrl = conversationModel.p2!.thumbUrl;
    }
    if (CommonUtils().auth.currentUser!.uid == conversationModel.p2?.uid) {
      ///self user
      reportedUid = conversationModel.p1!.uid;
      reportedName = conversationModel.p1!.name;
      reportedThumbUrl = conversationModel.p1!.thumbUrl;
    }
    ReportUserModel reportUserModel = ReportUserModel();
    reportUserModel.conversationId = conversationModel.id;
    reportUserModel.actionTaken = StringsNameUtils.reportedAction;
    reportUserModel.createdAt = Timestamp.fromDate(DateTime.now());
    reportUserModel.reportedBy = ReportedByUserModel(
        uid: reportedByUid, name: reportedByName, thumbUrl: reportedByThumbUrl);
    reportUserModel.reportedUser = ReportedUserModel(
        uid: reportedUid, name: reportedName, thumbUrl: reportedThumbUrl);

    FirebaseFirestore.instance
        .collection(StringsNameUtils.tblReportedUsers)
        .doc()
        .set(reportUserModel.toJson())
        .then(
      (_) {
        isUserReport.value = isReport;
        if (isAlsoBlocked) {
          userBlock(conversationModel, isAlsoBlocked);
        }
        Get.back();
      },
    ).catchError((error) {
      Get.back();
    });
  }

  Future<bool> checkUseIsReported({required String conversationId}) async {
    bool isUserReported = false;
    await FirebaseFirestore.instance
        .collection(StringsNameUtils.tblReportedUsers)
        .where('conversationId', isEqualTo: conversationId)
        .where('reportedBy.uid', isEqualTo: CommonUtils().auth.currentUser?.uid)
        .get()
        .then((value) {
      List.of(value.docs.map((e) {
        ReportUserModel reportUserModel = ReportUserModel.fromJson(e.data());
        if (reportUserModel.reportedUser?.uid == otherUserUid.value) {
          isUserReported = true;
        } else {
          isUserReported = false;
        }
      }));
    });
    return isUserReported;
  }

  List<dynamic> getSenderViewIndex(
      {bool isUpdate = false, bool isBothSame = false}) {
    if (!isFirstSender.value && !isLastSender.value) {
      isFirstSender.value = true;
      if (isBothSame) {
        isShowTime.value = true;
      } else {
        isShowTime.value = false;
      }
      return [0, senderLastItemDecoration()];
    } else if (!isLastSender.value) {
      isFirstSender.value = true;
      isShowTime.value = false;
      return [1, senderSecondItemDecoration()];
    } else if (isLastSender.value) {
      if (isUpdate) isLastSender.value = false;
      isShowTime.value = true;
      return [2, senderFirstItemDecoration()];
    }
    return [0];
  }

  List<dynamic> getReceiverViewIndex(
      {bool isUpdate = false, bool isBothSame = false}) {
    if (!isFirstReceiver.value && !isLastReceiver.value) {
      isFirstReceiver.value = true;
      if (isBothSame) {
        isReceiverShowTime.value = true;
      } else {
        isReceiverShowTime.value = false;
      }
      return [0, receiverLastItemDecoration()];
    } else if (!isLastReceiver.value) {
      isFirstReceiver.value = false;
      isReceiverShowTime.value = false;
      return [1, receiverSecondItemDecoration()];
    } else if (isLastReceiver.value) {
      if (isUpdate) isLastReceiver.value = false;
      isReceiverShowTime.value = true;
      return [2, receiverFirstItemDecoration()];
    }
    return [0];
  }

  BoxDecoration senderFirstItemDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(30)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.fillColorButtonGradientFirst.toColor(),
            AppColor.fillColorButtonGradientSecond.toColor(),
          ],
        ));
  }

  BoxDecoration receiverFirstItemDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30)),
        color: AppColor.colorDisabled.toColor());
  }

  BoxDecoration senderSecondItemDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.fillColorButtonGradientFirst.toColor(),
            AppColor.fillColorButtonGradientSecond.toColor(),
          ],
        ));
  }

  BoxDecoration receiverSecondItemDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30)),
        color: AppColor.colorDisabled.toColor());
  }

  BoxDecoration senderLastItemDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(10)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.fillColorButtonGradientFirst.toColor(),
            AppColor.fillColorButtonGradientSecond.toColor(),
          ],
        ));
  }

  BoxDecoration receiverLastItemDecoration() {
    return BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(10),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30)),
        color: AppColor.colorDisabled.toColor());
  }

  /// This method is send notification for chat
  void sendMessageNotification(
      {required String? conversationId, required String? messageId}) async {
    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();
    debugPrint('deleteAccount ===>  token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    requestParams = {
      'conversationId': conversationId,
      'messageId': messageId,
    };
    apiProvider
        .post(
            apiurl: ApiUrl.chatNotification,
            header: header,
            body: requestParams)
        .then(
      (value) {
        if (value.statusCode == 200) {
        } else if (value.statusCode == 404) {
          WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
        } else if (value.statusCode == 403) {
          WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
        } else if (value.statusCode == 401) {
          WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        }
      },
    );
  }

  getMessageLimit() {
    if (PreferenceUtils.getStartModelData?.currentSubscriptionPlan?.plan?.id ==
        1) {
      return 5;
    } else {
      return -1;
    }
  }

  /// This method is open Camera and capture image from camera
  /// Result of capture is store in image path variable
  openCamera(
      {required String imagePath,
      required Conversations? conversationModel,
      required int senderCount}) async {
    if (imagePath.endsWith(".png") ||
        imagePath.endsWith(".jpeg") ||
        imagePath.endsWith(".jpg")) {
      uploadImage(
          imagePath: path.basename(File(imagePath).path),
          file: File(imagePath),
          conversationModel: conversationModel,
          senderCount: senderCount);
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.imageExtensionError);
    }
  }

  /// This method is open Gallery and select image from gallery
  /// Result of selection is store in image path variable
  openGallery(
      {required Conversations? conversationModel,
      required int senderCount}) async {
    Get.back();
    await ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
      if (value!.path.endsWith(".png") ||
          value.path.endsWith(".jpeg") ||
          value.path.endsWith(".jpg")) {
        uploadImage(
            imagePath: path.basename(File(value.path).path),
            file: File(value.path),
            conversationModel: conversationModel,
            senderCount: senderCount);
      } else {
        WidgetHelper().showMessage(msg: StringsNameUtils.imageExtensionError);
      }
    });
  }

  uploadImage(
      {required String imagePath,
      required File file,
      required Conversations? conversationModel,
      required int senderCount}) async {
    if (Get.context != null) {
      UploadTask? uploadTask;
      CommonUtils().startLoading(Get.context!);

      final auth = FirebaseAuth.instance;
      String? token = await auth.currentUser?.getIdToken();

      //Create Reference
      Reference reference = FirebaseStorage.instance
          .ref('chat-media/')
          .child(conversationModel!.id!)
          .child(imagePath);

      //Now We have to check status of UploadTask
      uploadTask = reference.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
        switch (taskSnapshot.state) {
          case TaskState.running:
            break;
          case TaskState.canceled:
            CommonUtils().stopLoading(Get.context!);
            break;
          case TaskState.error:
            CommonUtils().stopLoading(Get.context!);
            break;
          case TaskState.success:
            // uploadImageToServer(taskSnapshot.ref.fullPath, token!);
            var photoUrl = await taskSnapshot.ref.getDownloadURL();
            debugPrint("ImageUrl ===> ${photoUrl.toString()}");
            sendChatMessage(
                conversationModel: conversationModel,
                messageType: 2,
                messageText: 'Photo',
                photoUrl: photoUrl.toString(),
                photoViewed: false,
                senderCount: senderCount,
                timestamp: Timestamp.fromDate(DateTime.now()));
            CommonUtils().stopLoading(Get.context!);
            uploadTask = null;
            break;
          case TaskState.paused:
            break;
        }
      });
    }
  }

  unMatchApiCall({required String unMatchUserId}) async {
    CommonUtils().startLoading(Get.context!);
    String? token = await CommonUtils().auth.currentUser?.getIdToken();
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    Map<String, String>? body = <String, String>{};

    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    body = {'userId': unMatchUserId};

    apiProvider
        .post(apiurl: ApiUrl.unMatch, header: header, body: body)
        .then((value) {
      CommonUtils().stopLoading(Get.context!);
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
        debugPrint("UnMatch ===> ${response}");
        UnMatchModel unMatchModel = UnMatchModel.fromJson(response);
        if (unMatchModel.success!) {
          Get.back();
        }
      } else if (value.statusCode == 404) {
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
      } else if (value.statusCode == 403) {
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
      } else if (value.statusCode == 401) {
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
      }
    });
  }

  navigateToBackScreen() {
    CommonUtils().backFromScreenOrExit(true, Routes.BACK_CHAT);
  }
}
