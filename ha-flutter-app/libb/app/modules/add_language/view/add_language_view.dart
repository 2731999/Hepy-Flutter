// ignore_for_file: invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/add_language/controller/add_language_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class AddLanguageView extends GetView<AddLanguageController> {
  AddLanguageController addLanguageController = AddLanguageController();

  AddLanguageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    addLanguageController.getLanguageAndSetIt();
    return Obx(
      () => WillPopScope(
        onWillPop: () {
          return addLanguageController.navigateToBackScreen();
        },
        child: Scaffold(
          appBar: WidgetHelper().showAppBar(
            isShowBackButton: true,
            onTap: () {
              addLanguageController.navigateToBackScreen();
            },
          ),
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 48, right: 20, left: 20),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 332,
                        child: WidgetHelper().titleTextView(
                            titleText: StringsNameUtils.languageTitle,
                            fontSize: 36),
                      ),
                      WidgetHelper().sizeBox(height: 12),
                      WidgetHelper().simpleText(
                          text: StringsNameUtils.languageContentMessage,
                          textAlign: TextAlign.center),
                    ],
                  ),
                  WidgetHelper().sizeBox(height: 20),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.52,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.builder(
                            physics: const ScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: addLanguageController
                                .lstSelectedLanguage.value.length,
                            itemBuilder: (context, index) {
                              var selectedLanguage = addLanguageController
                                  .lstSelectedLanguage.value[index];
                              return selectedLanguageItemView(selectedLanguage);
                            }),
                        WidgetHelper().sizeBox(height: 5),
                        InkWell(
                          onTap: () {
                            if (addLanguageController
                                    .lstSelectedLanguage.value.length <
                                5) {
                              addLanguageController.lstLanguages.clear();
                              addLanguageController.addLanguageToList();
                              WidgetHelper().showBottomSheetDialog(
                                  controller: showLanguageSelectionView(context),
                                  bottomSheetHeight:
                                      MediaQuery.of(context).size.height * 0.95);
                            } else {
                              WidgetHelper().showMessage(
                                  msg: StringsNameUtils.maxLanguageMessage);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            child: WidgetHelper().simpleTextWithPrimaryColor(
                                text: StringsNameUtils.addLanguage,
                                textAlign: TextAlign.start,
                                textColor: AppColor.colorPrimary.toColor(),
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  WidgetHelper().sizeBox(height: 20),
                  SizedBox(
                    width: 275,
                    child: WidgetHelper().fillColorButton(
                      ontap: () {
                        addLanguageController.insertSelectedLanguageToDB(isFromLanguage: true);
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
        ),
      ),
    );
  }

  showLanguageSelectionView(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: WidgetHelper().commonPaddingOrMargin(),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Image.asset(
                    ImagePathUtils.arrow_black_image,
                    width: 24,
                    height: 24,
                  ),
                  onTap: () {
                    Get.back();
                  },
                ),
                Expanded(
                  child: Center(
                    child: WidgetHelper().simpleTextWithPrimaryColor(
                        text: StringsNameUtils.selectLanguage,
                        textAlign: TextAlign.center,
                        textColor: AppColor.colorText.toColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          WidgetHelper().sizeBox(height: 15),
          Expanded(
            child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: addLanguageController.lstLanguages.value.length,
                itemBuilder: (context, index) {
                  var language =
                      addLanguageController.lstLanguages.value[index];
                  return languageItemView(language);
                }),
          )
        ],
      ),
    );
  }

  languageItemView(String language) {
    return InkWell(
      onTap: () {
        addLanguageController.addLanguageAsSelectedLanguage(language: language);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 7, right: 15, left: 15),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetHelper().simpleTextWithPrimaryColor(
                    text: language,
                    textAlign: TextAlign.start,
                    textColor: AppColor.colorText.toColor(),
                  ),
                ],
              ),
            ),
            WidgetHelper().sizeBox(height: 5),
            Divider(
              thickness: 0.5,
              color: AppColor.colorGray.toColor(),
            )
          ],
        ),
      ),
    );
  }

  selectedLanguageItemView(String language) {
    return Container(
      margin: const EdgeInsets.only(top: 5, right: 15, left: 15),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetHelper().simpleTextWithPrimaryColor(
                text: language,
                textAlign: TextAlign.start,
                textColor: AppColor.colorText.toColor(),
              ),
              GestureDetector(
                onTap: () {
                  addLanguageController.removeLanguageAsSelectedLanguage(
                      language: language);
                },
                child: Image.asset(
                  ImagePathUtils.close_image,
                  width: 25,
                  height: 25,
                ),
              )
            ],
          ),
          WidgetHelper().sizeBox(height: 5),
          Divider(
            thickness: 0.5,
            color: AppColor.colorGray.toColor(),
          )
        ],
      ),
    );
  }
}
