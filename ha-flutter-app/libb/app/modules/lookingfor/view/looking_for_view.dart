import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/lookingfor/controller/looking_for_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class LookingForView extends GetView<LookingForController> {
  LookingForController lookingForController = LookingForController();

  LookingForView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    lookingForController.getDataAndSetIt();
    return Obx(
      () => WillPopScope(
        onWillPop: () {
          return lookingForController.navigateToBackScreen();
        },
        child: Scaffold(
          appBar: WidgetHelper().showAppBar(
            isShowBackButton: true,
            onTap: () {
              lookingForController.navigateToBackScreen();
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
                    child: WidgetHelper().titleTextView(
                        titleText: StringsNameUtils.lookingForTitle,
                        fontSize: 36),
                  ),
                  WidgetHelper().sizeBox(height: 48),
                  WidgetHelper().genderController(
                    borderColor: lookingForController.isMenSelected.value
                        ? AppColor.colorPrimary.toColor()
                        : AppColor.colorGray.toColor(),
                    text: StringsNameUtils.men,
                    onTap: () {
                      lookingForController.menClicked();
                    },
                  ),
                  WidgetHelper().sizeBox(height: 12),
                  WidgetHelper().genderController(
                    borderColor: lookingForController.isWomenSelected.value
                        ? AppColor.colorPrimary.toColor()
                        : AppColor.colorGray.toColor(),
                    text: StringsNameUtils.women,
                    onTap: () {
                      lookingForController.womenClicked();
                    },
                  ),
                  WidgetHelper().sizeBox(height: 12),
                  WidgetHelper().genderController(
                    borderColor: lookingForController.isEveryoneSelected.value
                        ? AppColor.colorPrimary.toColor()
                        : AppColor.colorGray.toColor(),
                    text: StringsNameUtils.everyone,
                    onTap: () {
                      lookingForController.everyoneClicked();
                    },
                  ),
                  WidgetHelper().sizeBox(height: 24),
                  SizedBox(
                    width: 275,
                    child: WidgetHelper().fillColorButton(
                      ontap: () {
                        lookingForController.insertLookingForToDB(
                            lookingForController.selectedLookingFor.value,
                            context);
                      },
                      text: StringsNameUtils.continues,
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      height: 45,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
