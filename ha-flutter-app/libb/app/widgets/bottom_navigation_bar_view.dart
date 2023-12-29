import 'package:flutter/material.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/modules/dashboard/controller/dashboard_controller.dart';

class BottomNavigationBarView {
  BottomNavigationBar bottomNavigationBar(
      {required DashboardController dashboardController}) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColor.colorPrimary.toColor(),
      unselectedItemColor: AppColor.colorGray.toColor(),
      selectedFontSize: 14,
      unselectedFontSize: 14,
      elevation: 0.0,
      onTap: (value) {
        // Respond to item press.
        manageSelection(value, dashboardController);
      },
      items: [
        BottomNavigationBarItem(
          label: '',
          icon: ImageIcon(
            AssetImage(dashboardController.isHomeSelected.value
                ? ImagePathUtils.home_image_primary
                : ImagePathUtils.home_image),
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: ImageIcon(
            AssetImage(dashboardController.isLikeSelected.value
                ? ImagePathUtils.home_like_image
                : ImagePathUtils.home_like_primary),
            size: 30,
          ),
        ),
        BottomNavigationBarItem(
          label: '',
          icon: ImageIcon(
            AssetImage(dashboardController.isChatSelected.value
                ? ImagePathUtils.home_chat_image
                : ImagePathUtils.home_chat_primary),
            size: 30,
          ),
        ),
      ],
    );
  }

  manageSelection(int value, DashboardController dashboardController) {
    switch (value) {
      case 0:
        makeSelection(
            isHomeSelected: true,
            isLikeSelected: false,
            isChatSelected: false,
            dashboardController: dashboardController);
        break;
      case 1:
        dashboardController.likeViewApiCall();
        makeSelection(
            isHomeSelected: false,
            isLikeSelected: true,
            isChatSelected: false,
            dashboardController: dashboardController);
        break;
      case 2:
        makeSelection(
            isHomeSelected: false,
            isLikeSelected: false,
            isChatSelected: true,
            dashboardController: dashboardController);
        break;
    }
  }

  makeSelection(
      {required bool isHomeSelected,
      required bool isLikeSelected,
      required bool isChatSelected,
      required DashboardController dashboardController}) {
    dashboardController.isHomeSelected.value = isHomeSelected;
    dashboardController.isLikeSelected.value = isLikeSelected;
    dashboardController.isChatSelected.value = isChatSelected;
  }
}
