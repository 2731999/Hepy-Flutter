import 'package:get/get.dart';
import 'package:hepy/app/modules/chat/controller/chat_controller.dart';
import 'package:hepy/app/modules/like/controller/like_controller.dart';

class DashboardController extends GetxController {
  RxBool isHomeSelected = false.obs;
  RxBool isLikeSelected = false.obs;
  RxBool isChatSelected = false.obs;
  RxString? isProfileUpdate = "".obs;
  RxBool isFromNotification = false.obs;
  bool isLikedViewClicked = false;
  bool isChatClicked = false;

  RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {}

  void changeTabIndex(int index) async {
    tabIndex.value = index;
    if (index == 1) {
      likeViewApiCall();
    } else if (index == 2) {
      chatViewApiCall();
    }
  }

  int getSelectedTabIndex(int value) {
    if (isFromNotification.value) {
      isFromNotification.value = false;
      return tabIndex.value = value;
    } else {
      return tabIndex.value;
    }
    update();
  }

  void likeViewApiCall() {
    LikeController.isNeedToCallApi = true;
    isLikedViewClicked = true;
  }

  void chatViewApiCall() {
    ChatController.isNeedToChatCallApi = true;
  }
}
