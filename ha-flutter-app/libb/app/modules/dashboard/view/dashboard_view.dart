import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/animation/fade_indexed_stack.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/modules/chat/view/chat_view.dart';
import 'package:hepy/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:hepy/app/modules/home/view/home_view.dart';
import 'package:hepy/app/modules/like/view/like_view.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:provider/provider.dart';

class DashboardView extends GetView<DashboardController> {
  //todo temp change
  DashboardController dashboardController = DashboardController();

  DashboardView({Key? key}) : super(key: key);

  // UserCardsModel userDetails = Get.arguments[0];

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null &&
        !dashboardController.isFromNotification.value) {
      dashboardController.isFromNotification.value = Get.arguments[1];
    }
    return Obx(
      () => Scaffold(
        appBar: WidgetHelper().homeAppBar(),
        backgroundColor: AppColor.colorWhite.toColor(),
        body: Center(
          child: FadeIndexedStack(
            //this is optional
            duration: const Duration(seconds: 2),
            index: dashboardController.getSelectedTabIndex(Get.arguments != null
                ? Get.arguments[0]
                : dashboardController.tabIndex.value),
            children: [HomeView(), LikeView(), ChatView()],
          ),
        ),
        bottomNavigationBar:
            bottomNavigationBar(dashboardController: dashboardController),
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar(
      {required DashboardController dashboardController}) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      unselectedItemColor: AppColor.colorGray.toColor(),
      selectedItemColor: AppColor.colorPrimary.toColor(),
      onTap: dashboardController.changeTabIndex,
      currentIndex: dashboardController.getSelectedTabIndex(
          Get.arguments != null
              ? Get.arguments[0]
              : dashboardController.tabIndex.value),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      elevation: 0.0,
      items: const [
        BottomNavigationBarItem(
          label: '',
          icon: ImageIcon(
            AssetImage(ImagePathUtils.home_image),
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: ImageIcon(
            AssetImage(ImagePathUtils.home_like_primary),
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: ImageIcon(
            AssetImage(ImagePathUtils.home_chat_image),
            size: 30,
          ),
        ),
      ],
    );
  }
}
