import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/banned/controller/banned_view_controller.dart';
import 'package:hepy/app/modules/setting/controller/setting_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

import '../../../Utils/app_color.dart';

class BannedView extends GetView<SettingController> {
  BannedViewController mBannedViewController = BannedViewController();

  BannedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().showAppBar(isShowBackButton: false),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(right: 20, left: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                WidgetHelper().simpleTextWithPrimaryColor(
                    textColor: AppColor.colorText.toColor(),
                    text: StringsNameUtils.bannedTitle,
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                WidgetHelper().sizeBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                      textColor: AppColor.colorGray.toColor(),
                      text: StringsNameUtils.bannedContentMessage,
                      textAlign: TextAlign.center,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                WidgetHelper().sizeBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        AppColor.colorTranGray.toColor()),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        side:
                            BorderSide(color: AppColor.colorTranGray.toColor()),
                      ),
                    ),
                  ),
                  onPressed: () {
                    CommonUtils().logoutUser(context);
                  },
                  child: Text(
                    StringsNameUtils.logout,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColor.colorText.toColor(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
