import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/dob/controller/dob_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class DobView extends GetView<DobController> {
  DobController dobController = Get.put(DobController());

  DobView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().showAppBar(
        onTap: () {
          dobController.navigateToBackScreen();
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(top: 48, right: 20, left: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 332,
                child: WidgetHelper()
                    .titleTextView(titleText: StringsNameUtils.dobTitle,fontSize: 32),
              ),
              WidgetHelper().sizeBox(height: 48),
              Image.asset(
                ImagePathUtils.dob_image,
                fit: BoxFit.contain,
                height: 96,
                width: 96,
              ),
              GestureDetector(
                onTap: () {
                  dobController.showDatePickerDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      child: WidgetHelper().textField(
                        controller: dobController.dayController.value,
                        hint: "DD",
                        padding:
                            const EdgeInsets.only(top: 30, right: 15, left: 15),
                        isEnabled: false,
                        isShowLabel: false,
                        textAlign: TextAlign.center,
                        textColor: AppColor.colorGray.toColor(),
                      ),
                    ),
                    SizedBox(
                      width: 90,
                      child: WidgetHelper().textField(
                        controller: dobController.monthController.value,
                        hint: "MM",
                        padding:
                            const EdgeInsets.only(top: 30, right: 15, left: 15),
                        isEnabled: false,
                        isShowLabel: false,
                        textAlign: TextAlign.center,
                        textColor: AppColor.colorGray.toColor(),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: WidgetHelper().textField(
                        controller: dobController.yearController.value,
                        hint: "YYYY",
                        padding:
                            const EdgeInsets.only(top: 30, right: 15, left: 15),
                        isEnabled: false,
                        isShowLabel: false,
                        textAlign: TextAlign.center,
                        textColor: AppColor.colorGray.toColor(),
                      ),
                    )
                  ],
                ),
              ),
              WidgetHelper().sizeBox(height: 24),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.dobContentMessage,
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 24),
              SizedBox(
                width: 275,
                child: WidgetHelper().fillColorButton(
                  ontap: () {
                    dobController.navigateToGenderScreen();
                  },
                  text: StringsNameUtils.continues,
                  margin: const EdgeInsets.only(top: 15, bottom: 15),
                  height: 48,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
