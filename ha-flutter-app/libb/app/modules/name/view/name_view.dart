import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/name/contoller/name_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class NameView extends GetView<NameController> {
  NameController nameController = Get.put(NameController());

  NameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: WidgetHelper().showAppBar(),
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
                    titleText: StringsNameUtils.nameTitle, fontSize: 32),
              ),
              WidgetHelper().sizeBox(height: 12),
              SizedBox(
                width: 332,
                child: WidgetHelper().simpleText(
                    text: StringsNameUtils.nameContentMessage,
                    textAlign: TextAlign.center),
              ),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().textField(
                  controller: nameController.firstNameController.value,
                  hint: StringsNameUtils.firstName,
                  padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
                  textColor: AppColor.colorText.toColor(),
                  underlineColor: AppColor.colorPrimary.toColor()),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().textField(
                controller: nameController.lastNameController.value,
                hint: StringsNameUtils.lastName,
                padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                textColor: AppColor.colorText.toColor(),
                underlineColor: AppColor.colorPrimary.toColor(),
              ),
              WidgetHelper().sizeBox(height: 24),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.nameMessage,
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 23),
              WidgetHelper().fillColorButton(
                ontap: () {
                  nameController.insertDataToDB();
                },
                text: StringsNameUtils.continues,
                margin: const EdgeInsets.only(top: 25, bottom: 15),
                height: 45,
              )
            ],
          ),
        ),
      ),
    );
  }
}
