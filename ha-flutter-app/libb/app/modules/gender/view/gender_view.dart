import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/gender/controller/getnder_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class GenderView extends StatefulWidget {
  GenderView({Key? key}) : super(key: key);
  GenderController genderController = GenderController();

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {

  @override
  void initState() {
    widget.genderController.getDataAndSetIt();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => widget.genderController.isLoading.value
          ? Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : WillPopScope(
              onWillPop: () {
                return widget.genderController.navigateToBackScreen();
              },
              child: Scaffold(
                appBar: WidgetHelper().showAppBar(
                  onTap: () {
                    widget.genderController.navigateToBackScreen();
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
                              titleText: StringsNameUtils.genderTitle,
                              fontSize: 36),
                        ),
                        WidgetHelper().sizeBox(height: 12),
                        WidgetHelper().simpleText(
                            text: StringsNameUtils.genderContentMessage,
                            textAlign: TextAlign.center),
                        WidgetHelper().sizeBox(height: 48),
                        WidgetHelper().genderController(
                          borderColor: widget.genderController.isMaleSelected.value
                              ? AppColor.colorPrimary.toColor()
                              : AppColor.colorGray.toColor(),
                          text: StringsNameUtils.male,
                          onTap: () {
                            debugPrint("Male Clicked");
                            widget.genderController.maleClicked();
                          },
                        ),
                        WidgetHelper().sizeBox(height: 12),
                        WidgetHelper().genderController(
                          borderColor: widget.genderController.isFemaleSelected.value
                              ? AppColor.colorPrimary.toColor()
                              : AppColor.colorGray.toColor(),
                          text: StringsNameUtils.female,
                          onTap: () {
                            debugPrint("Female Clicked");
                            widget.genderController.femaleClicked();
                          },
                        ),
                        WidgetHelper().sizeBox(height: 12),
                        WidgetHelper().genderController(
                          borderColor: widget.genderController.isOtherSelected.value
                              ? AppColor.colorPrimary.toColor()
                              : AppColor.colorGray.toColor(),
                          text: StringsNameUtils.other,
                          onTap: () {
                            debugPrint("Other Clicked");
                            widget.genderController.otherClicked();
                          },
                        ),
                        WidgetHelper().sizeBox(height: 24),
                        WidgetHelper().fillColorButton(
                          ontap: () {
                            widget.genderController.insertGenderToDB(
                                widget.genderController.selectedGender.value);
                          },
                          text: StringsNameUtils.continues,
                          margin: const EdgeInsets.only(top: 15, bottom: 15),
                          height: 45,
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

