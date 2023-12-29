import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/email/controller/email_controller.dart';
import 'package:hepy/app/modules/welcome/controller/welcome_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class EmailView extends GetView<EmailController> {
  EmailController emailController = EmailController();
  WelcomeController welcomeController = WelcomeController();

  EmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => emailController.isLoader.value
          ? Container(
              color: AppColor.colorWhite.toColor(),
              child: const Center(child: CircularProgressIndicator()),
            )
          : WillPopScope(
              onWillPop: () {
                return emailController.navigateToBackScreen();
              },
              child: Scaffold(
                appBar: WidgetHelper().showAppBar(
                  isShowBackButton: true,
                  onTap: () => emailController.navigateToBackScreen(),
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
                          child: Wrap(
                            children: [
                              WidgetHelper().titleTextView(
                                  titleText: StringsNameUtils.emailTitle,
                                  fontSize: 36),
                            ],
                          ),
                        ),
                        WidgetHelper().sizeBox(height: 12),
                        WidgetHelper().simpleText(
                            text: StringsNameUtils.emailContentMessage,
                            textAlign: TextAlign.center),
                        WidgetHelper().sizeBox(height: 30),
                        WidgetHelper().textField(
                            controller: emailController.emailController.value,
                            hint: StringsNameUtils.email,
                            padding: const EdgeInsets.only(
                                top: 40, right: 20, left: 20),
                            textColor: AppColor.colorText.toColor(),
                            underlineColor: AppColor.colorPrimary.toColor(),
                            keyboardType: TextInputType.emailAddress),
                        WidgetHelper().sizeBox(height: 23),
                        WidgetHelper().fillColorButton(
                          ontap: () => emailController.insertDataToDB(
                              welcomeController, context),
                          text: StringsNameUtils.done,
                          margin: const EdgeInsets.only(top: 25, bottom: 15),
                          height: 45,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
