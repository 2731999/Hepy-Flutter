import 'dart:io';

import 'package:android_power_manager/android_power_manager.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Database/profile_boost_history_tbl.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/widgets/swipecards/card_provider.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {



  insertBoostTimeToDb(CardProvider provider) async{
    UserTbl().boostProfileTiming(CommonUtils().auth.currentUser!);
    await ProfileBoostHistoryTbl()
        .insertBoostHistoryData(uid: CommonUtils().auth.currentUser!.uid);
    PreferenceUtils.setBoostUser = false;
    provider.isBoosterClciked = false;
    provider.notifyListeners();
    WidgetHelper().showMessage(msg: StringsNameUtils.profileBoostingMessage);
  }

  Future<void> requestBatteryOptimisationPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.ignoreBatteryOptimizations.status;
      print("status: $status");
      if (status.isGranted) {
        print(
            "isIgnoring: ${(await AndroidPowerManager.isIgnoringBatteryOptimizations)}");
        if (await AndroidPowerManager.isIgnoringBatteryOptimizations != null) {
          bool? op = await AndroidPowerManager.isIgnoringBatteryOptimizations;
          try {
            if (op!) {
              AndroidPowerManager.requestIgnoreBatteryOptimizations();
            }
          } catch (e) {
            print(e);
          }
        }
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.ignoreBatteryOptimizations,
        ].request();
        print(
            "permission value: ${statuses[Permission.ignoreBatteryOptimizations]}");
        if (statuses[Permission.ignoreBatteryOptimizations]!.isGranted) {
          AndroidPowerManager.requestIgnoreBatteryOptimizations();
        } /*else {
        exit(0);
      }*/
      }
    }
  }

}
