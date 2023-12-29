import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/qod/controller/qod_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class QODView extends GetView<QODController> {
  // todo temp change
  QODController qodController = Get.put(QODController());

  QODView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => !qodController.isLoading.value
          ? Scaffold(
              appBar: WidgetHelper().homeAppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(right: 20, left: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 332,
                          child: WidgetHelper().titleTextView(
                              titleText: StringsNameUtils.qodTitle,
                              fontSize: 32),
                        ),
                        WidgetHelper().sizeBox(height: 16),
                        WidgetHelper().simpleText(
                            text: StringsNameUtils.qodContentMessage,
                            textAlign: TextAlign.center),
                        WidgetHelper().sizeBox(height: 48),
                        Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: AppColor.colorPrimary.toColor(),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: WidgetHelper().simpleTextWithPrimaryColor(
                            text: qodController.question.value,
                            textColor: AppColor.colorWhite.toColor(),
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        WidgetHelper().sizeBox(height: 48),
                        Container(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: WidgetHelper().primaryOutlinedButton(
                            text: qodController.firstOption.value.toUpperCase(),
                            onPressed: () => qodController.insertAnswerInToDatabase(
                                answer: qodController.firstOption.value,
                                context: context
                            )
                          )
                        ),
                        WidgetHelper().sizeBox(height: 24),
                        Container(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: WidgetHelper().primaryOutlinedButton(
                            text: qodController.secondOption.value.toUpperCase(),
                            onPressed: () => qodController.insertAnswerInToDatabase(
                                answer: qodController.secondOption.value,
                                context: context),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : WidgetHelper().loaderWithWhiteBg(),
    );
  }
}
