import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/enum/about_me.dart';
import 'package:hepy/app/modules/aboutme/controller/about_me_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class AboutMeView extends GetView<AboutMeController> {
  AboutMeController aboutMeController = AboutMeController();

  AboutMeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    aboutMeController.isShowLoader.value = true;
    aboutMeController.getHeightAndSetIt();
    return Obx(
      () => aboutMeController.isShowLoader.value
          ? Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : WillPopScope(
              onWillPop: () {
                return aboutMeController.back(isPreviousScreen: true);
              },
              child: Scaffold(
                appBar: WidgetHelper().showAppBar(
                  isShowBackButton: true,
                  onTap: () {
                    aboutMeController.back(isPreviousScreen: true);
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
                              titleText: StringsNameUtils.aboutMeTitle,
                              fontSize: 36),
                        ),
                        WidgetHelper().sizeBox(height: 12),
                        WidgetHelper().simpleText(
                            text: StringsNameUtils.aboutMeContentMessage,
                            textAlign: TextAlign.center),
                        WidgetHelper().sizeBox(height: 36),
                        aboutMeCommonView(
                            StringsNameUtils.height,
                            (aboutMeController.height.value!=null && aboutMeController.height.isNotEmpty)
                                ? '${aboutMeController.height.value} cm'
                                : '',
                            () => heightClick(context)),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeDivider(),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeCommonView(
                            StringsNameUtils.exercise,
                            aboutMeController.exercise.value,
                            () => exerciseClick(context)),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeDivider(),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeCommonView(
                            StringsNameUtils.zodiac,
                            aboutMeController.zodiac.value,
                            () => zodiacClick(context)),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeDivider(),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeCommonView(
                            StringsNameUtils.educationLevel,
                            aboutMeController.educationLevel.value,
                            () => educationLevelClick(context)),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeDivider(),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeCommonView(
                            StringsNameUtils.drinking,
                            aboutMeController.drinking.value,
                            () => drinkingClick(context)),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeDivider(),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeCommonView(
                            StringsNameUtils.smoking,
                            aboutMeController.smoking.value,
                            () => smokingClick(context)),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeDivider(),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeCommonView(
                            StringsNameUtils.kids,
                            aboutMeController.kids.value,
                            () => kidsClick(context)),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeDivider(),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeCommonView(
                            StringsNameUtils.religion,
                            aboutMeController.religion.value,
                            () => religionClick(context)),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeDivider(),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeCommonView(
                            StringsNameUtils.politics,
                            aboutMeController.politics.value,
                            () => politicsClick(context)),
                        WidgetHelper().sizeBox(height: 10),
                        aboutMeDivider(),
                        WidgetHelper().sizeBox(height: 9),
                        WidgetHelper().fillColorButton(
                          ontap: () {
                            aboutMeController.updateSignupStatus();
                          },
                          text: StringsNameUtils.continues,
                          margin: const EdgeInsets.only(top: 15),
                          height: 45,
                        ),
                        WidgetHelper().sizeBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  ///AboutMe View
  aboutMeCommonView(String aboutMeName, String aboutMeValue, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 7, right: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: WidgetHelper()
                  .simpleText(text: aboutMeName, textAlign: TextAlign.start),
            ),
            SizedBox(
              width: 150,
              child: WidgetHelper().simpleTextWithPrimaryColor(
                  text: aboutMeValue.isEmpty ? "Add" : aboutMeValue,
                  textColor: aboutMeValue.isEmpty
                      ? AppColor.colorPrimary.toColor()
                      : AppColor.colorText.toColor(),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: aboutMeValue.isEmpty
                      ? FontWeight.bold
                      : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  ///Divider view
  aboutMeDivider() {
    return Divider(
      color: AppColor.colorGray.toColor(),
    );
  }

  /// Height Editing View
  heightEditingView(context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: WidgetHelper().commonPaddingOrMargin(),
        margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            WidgetHelper().titleTextView(titleText: StringsNameUtils.height),
            WidgetHelper().sizeBox(height: 20),
            WidgetHelper().simpleText(
                text: StringsNameUtils.heightContent,
                textAlign: TextAlign.center),
            WidgetHelper().sizeBox(height: 40),
            WidgetHelper().textField(
                controller: aboutMeController.heightController.value,
                hint: StringsNameUtils.heightContentHint,
                isEnabled: true,
                isShowLabel: false,
                textAlign: TextAlign.center,
                textColor: AppColor.colorText.toColor(),
                keyboardType: TextInputType.number,
                isFocusable: true),
            WidgetHelper().sizeBox(height: 40),
            WidgetHelper().fillColorButton(
              ontap: () {
                aboutMeController.setHeightValue();
              },
              text: StringsNameUtils.add,
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              height: 45,
            ),
            WidgetHelper().sizeBox(height: 20),
            WidgetHelper().cancelColorButton(
                text: StringsNameUtils.clear,
                height: 45,
                ontap: () {
                  aboutMeController.clearHeightValue();
                })
          ],
        ),
      ),
    );
  }

  /// Height view Click
  heightClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: heightEditingView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 1.0);
  }

  /// Exercise view where we can show list of exercise
  exerciseEditingView(context) {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: WidgetHelper().commonPaddingOrMargin(),
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WidgetHelper()
                  .titleTextView(titleText: StringsNameUtils.exercise),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.exerciseContent,
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.exerciseAerobic,
                    aboutMeController.isAerobicSelected.value,
                    true,
                    () {
                      aboutMeController.aerobicExerciseSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.exerciseStretching,
                    aboutMeController.isStretchingSelected.value,
                    true,
                    () {
                      aboutMeController.stretchingExerciseSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.exerciseCardo,
                    aboutMeController.isStretchingCardo.value,
                    true,
                    () {
                      aboutMeController.cardioExerciseSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.exerciseDance,
                    aboutMeController.isDanceSelected.value,
                    true,
                    () {
                      aboutMeController.danceExerciseSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.exerciseRunning,
                    aboutMeController.isRunningSelected.value,
                    true,
                    () {
                      aboutMeController.runningExerciseSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.exerciseWalking,
                    aboutMeController.isWalkingSelected.value,
                    true,
                    () {
                      aboutMeController.walkingExerciseSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 10),
              aboutMeDivider(),
              WidgetHelper().sizeBox(height: 20),
              clearView(aboutMeController.isExerciseSelected.value,
                  StringsNameUtils.exerciseRemove, () {
                aboutMeController.exerciseSelection(
                    isInsert: true, exerciseValue: '');
              }),
              WidgetHelper().sizeBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// Exercise click
  exerciseClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: exerciseEditingView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.50);
  }

  ///Zodiac view where we can see list of zodiac
  zodiacEditingView(context) {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: WidgetHelper().commonPaddingOrMargin(),
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WidgetHelper().titleTextView(titleText: StringsNameUtils.zodiac),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.zodiacContent,
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.zodiacAries,
                    aboutMeController.isZodiacAriesSelected.value,
                    true,
                    () {
                      aboutMeController.ariseZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.zodiacTaurus,
                    aboutMeController.isZodiacTaurusSelected.value,
                    true,
                    () {
                      aboutMeController.taurusZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.zodiacGemini,
                    aboutMeController.isZodiacGeminiSelected.value,
                    true,
                    () {
                      aboutMeController.geminiZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.zodiacCancer,
                    aboutMeController.isZodiacCancerSelected.value,
                    true,
                    () {
                      aboutMeController.cancerZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.zodiacLeo,
                    aboutMeController.isZodiacLeoSelected.value,
                    true,
                    () {
                      aboutMeController.leoZodiacSelection(isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.zodiacVirgo,
                    aboutMeController.isZodiacVirgoSelected.value,
                    true,
                    () {
                      aboutMeController.virgoZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.zodiacLibra,
                    aboutMeController.isZodiacLibraSelected.value,
                    true,
                    () {
                      aboutMeController.libraZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.zodiacScorpio,
                    aboutMeController.isZodiacScorpioSelected.value,
                    true,
                    () {
                      aboutMeController.scorpioZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.zodiacSagittarius,
                    aboutMeController.isZodiacSagittariusSelected.value,
                    true,
                    () {
                      aboutMeController.sagittariusZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.zodiacCapricorn,
                    aboutMeController.isZodiacCapricornSelected.value,
                    true,
                    () {
                      aboutMeController.capricornZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.zodiacAquarius,
                    aboutMeController.isZodiacAquariusSelected.value,
                    true,
                    () {
                      aboutMeController.aquariusZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.zodiacPisces,
                    aboutMeController.isZodiacPiscesSelected.value,
                    false,
                    () {
                      aboutMeController.piscesZodiacSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 10),
              aboutMeDivider(),
              WidgetHelper().sizeBox(height: 20),
              clearView(aboutMeController.isZodiacSelected.value,
                  StringsNameUtils.zodiacRemove, () {
                aboutMeController.zodiacSelection(
                    isInsert: true, zodiacValue: '');
              }),
              WidgetHelper().sizeBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///Zodiac Click
  zodiacClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: zodiacEditingView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.60);
  }

  ///Education level view where we can see list of education
  educationLevelEditingView(context) {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: WidgetHelper().commonPaddingOrMargin(),
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WidgetHelper()
                  .titleTextView(titleText: StringsNameUtils.educationLevel),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.eduContent,
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.eduHighSchool.toUpperCase(),
                    aboutMeController.isEduHighSchoolSelected.value,
                    true,
                    () {
                      aboutMeController.highSchoolEducationSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.eduVocationalSchool.toUpperCase(),
                    aboutMeController.isEduVocationalSchoolSelected.value,
                    true,
                    () {
                      aboutMeController.vocationalSchoolEducationSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.eduInCollage.toUpperCase(),
                    aboutMeController.isEduInCollageSelected.value,
                    true,
                    () {
                      aboutMeController.inCollageEducationSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.eduUnderGraduate.toUpperCase(),
                    aboutMeController.isEduUnderGraduateSelected.value,
                    true,
                    () {
                      aboutMeController.underGraduateEducationSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.eduInGradSchool.toUpperCase(),
                    aboutMeController.isEduInGradeSelected.value,
                    true,
                    () {
                      aboutMeController.inGradeEducationSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.eduGraduateDegree.toUpperCase(),
                    aboutMeController.isEduGraduateSelected.value,
                    true,
                    () {
                      aboutMeController.graduateDegreeEducationSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 10),
              aboutMeDivider(),
              WidgetHelper().sizeBox(height: 20),
              clearView(aboutMeController.isEduSelected.value,
                  StringsNameUtils.eduRemove, () {
                aboutMeController.educationLevelSelection(
                    isInsert: true, education: '');
              }),
              WidgetHelper().sizeBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///EducationLevel Click
  educationLevelClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: educationLevelEditingView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.55);
  }

  ///Drinking view where we can see list of drinking
  drinkingEditingView(context) {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: WidgetHelper().commonPaddingOrMargin(),
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WidgetHelper()
                  .titleTextView(titleText: StringsNameUtils.drinking),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.drinkContent,
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.drinkSocially.toUpperCase(),
                    aboutMeController.isDrinkSocially.value,
                    true,
                    () {
                      aboutMeController.sociallyDrinkingSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.drinkNever.toUpperCase(),
                    aboutMeController.isDrinkNever.value,
                    true,
                    () {
                      aboutMeController.neverDrinkingSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.drinkFrequently.toUpperCase(),
                    aboutMeController.isDrinkFrequently.value,
                    true,
                    () {
                      aboutMeController.frequentlyDrinkingSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.drinkSober.toUpperCase(),
                    aboutMeController.isDrinkSober.value,
                    false,
                    () {
                      aboutMeController.soberDrinkingSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 10),
              aboutMeDivider(),
              WidgetHelper().sizeBox(height: 20),
              clearView(aboutMeController.isDrinkSelected.value,
                  StringsNameUtils.drinkRemove, () {
                aboutMeController.drinkingSelection(isInsert: true, drink: '');
              }),
              WidgetHelper().sizeBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///Drinking Click
  drinkingClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: drinkingEditingView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.50);
  }

  ///Smoking view where we can see list of smoking
  smokingEditingView(context) {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: WidgetHelper().commonPaddingOrMargin(),
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WidgetHelper().titleTextView(titleText: StringsNameUtils.smoking),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.smokeContent,
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.smokeSocially.toUpperCase(),
                    aboutMeController.isSmokeSocially.value,
                    true,
                    () {
                      aboutMeController.sociallySmokingSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.smokeNever.toUpperCase(),
                    aboutMeController.isSmokeNever.value,
                    true,
                    () {
                      aboutMeController.neverSmokingSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.smokeRegularly.toUpperCase(),
                    aboutMeController.isSmokeRegularly.value,
                    true,
                    () {
                      aboutMeController.regularlySmokingSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 10),
              aboutMeDivider(),
              WidgetHelper().sizeBox(height: 20),
              clearView(aboutMeController.isSmokeSelected.value,
                  StringsNameUtils.smokeRemove, () {
                aboutMeController.smokingSelection(isInsert: true, smoke: '');
              }),
              WidgetHelper().sizeBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///Smoking Click
  smokingClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: smokingEditingView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.40);
  }

  ///Kids view where we can see list of kids
  kidsEditingView(context) {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: WidgetHelper().commonPaddingOrMargin(),
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WidgetHelper().titleTextView(titleText: StringsNameUtils.kids),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.kidsContent,
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.kidsSomeDay.toUpperCase(),
                    aboutMeController.isKidsWant.value,
                    true,
                    () {
                      aboutMeController.wantSomeDayKidsSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.kidsDoNotWant.toUpperCase(),
                    aboutMeController.isKidsDoNotWant.value,
                    true,
                    () {
                      aboutMeController.doNotWantKidsSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.kidsMore.toUpperCase(),
                    aboutMeController.isKidsMore.value,
                    true,
                    () {
                      aboutMeController.wantMoreKidsSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.kidsHave.toUpperCase(),
                    aboutMeController.isKidsHave.value,
                    true,
                    () {
                      aboutMeController.doNotWantMoreKidsSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.kidsNoSure.toUpperCase(),
                    aboutMeController.isKidsNotSure.value,
                    false,
                    () {
                      aboutMeController.notSureKidsSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 10),
              aboutMeDivider(),
              WidgetHelper().sizeBox(height: 20),
              clearView(aboutMeController.isKidsSelected.value,
                  StringsNameUtils.kidsRemove, () {
                aboutMeController.kidsSelection(isInsert: true, kids: '');
              }),
              WidgetHelper().sizeBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///Kids Click
  kidsClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: kidsEditingView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.55);
  }

  ///Religion view where we can see list of Religion
  religionEditingView(context) {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: WidgetHelper().commonPaddingOrMargin(),
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WidgetHelper()
                  .titleTextView(titleText: StringsNameUtils.religion),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.religionContent,
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.religionAgnostic.toUpperCase(),
                    aboutMeController.isReliAgnostic.value,
                    true,
                    () {
                      aboutMeController.agnosticReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionAtheist.toUpperCase(),
                    aboutMeController.isReliAtheist.value,
                    true,
                    () {
                      aboutMeController.atheistReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionBuddhist.toUpperCase(),
                    aboutMeController.isReliBuddhist.value,
                    true,
                    () {
                      aboutMeController.buddhistReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionCatholic.toUpperCase(),
                    aboutMeController.isReliCatholic.value,
                    true,
                    () {
                      aboutMeController.catholicReligionSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.religionChristian.toUpperCase(),
                    aboutMeController.isReliChristian.value,
                    true,
                    () {
                      aboutMeController.christianReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionHindu.toUpperCase(),
                    aboutMeController.isReliHindu.value,
                    true,
                    () {
                      aboutMeController.hinduReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionJain.toUpperCase(),
                    aboutMeController.isReliJain.value,
                    true,
                    () {
                      aboutMeController.jainReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionJewish.toUpperCase(),
                    aboutMeController.isReliJewish.value,
                    true,
                    () {
                      aboutMeController.jewishReligionSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.religionMormon.toUpperCase(),
                    aboutMeController.isReliMormon.value,
                    true,
                    () {
                      aboutMeController.mormonReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionMuslim.toUpperCase(),
                    aboutMeController.isReliMuslim.value,
                    true,
                    () {
                      aboutMeController.muslimReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionZoroastrian.toUpperCase(),
                    aboutMeController.isReliZoroastrian.value,
                    true,
                    () {
                      aboutMeController.zoroastrianReligionSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.religionSikh.toUpperCase(),
                    aboutMeController.isReliSikh.value,
                    true,
                    () {
                      aboutMeController.sikhReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionSpiritual.toUpperCase(),
                    aboutMeController.isReliSpiritual.value,
                    true,
                    () {
                      aboutMeController.spiritualReligionSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.religionOther.toUpperCase(),
                    aboutMeController.isReliOther.value,
                    true,
                    () {
                      aboutMeController.otherReligionSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 10),
              aboutMeDivider(),
              WidgetHelper().sizeBox(height: 20),
              clearView(aboutMeController.isReligionSelected.value,
                  StringsNameUtils.religionRemove, () {
                aboutMeController.religionSelection(
                    isInsert: true, religion: '');
              }),
              WidgetHelper().sizeBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///Religion Click
  religionClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: religionEditingView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.63);
  }

  ///Politics view where we can see list of Politics
  politicsEditingView(context) {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: WidgetHelper().commonPaddingOrMargin(),
          margin: const EdgeInsets.only(top: 30, right: 20, left: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WidgetHelper()
                  .titleTextView(titleText: StringsNameUtils.politics),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().simpleText(
                  text: StringsNameUtils.politicsContent.toUpperCase(),
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.politicsApolitical.toUpperCase(),
                    aboutMeController.isPoliticApolitical.value,
                    true,
                    () {
                      aboutMeController.apoliticalPoliticsSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.politicsModerate.toUpperCase(),
                    aboutMeController.isPoliticModerate.value,
                    true,
                    () {
                      aboutMeController.moderatePoliticsSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.politicsLeft.toUpperCase(),
                    aboutMeController.isPoliticLeft.value,
                    true,
                    () {
                      aboutMeController.leftPoliticsSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  commonView(
                    context,
                    StringsNameUtils.politicsRight.toUpperCase(),
                    aboutMeController.isPoliticRight.value,
                    true,
                    () {
                      aboutMeController.rightPoliticsSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.politicsCommunist.toUpperCase(),
                    aboutMeController.isPoliticCommunist.value,
                    true,
                    () {
                      aboutMeController.communistPoliticsSelection(
                          isInsertData: true);
                    },
                  ),
                  commonView(
                    context,
                    StringsNameUtils.politicsSocialist.toUpperCase(),
                    aboutMeController.isPoliticSocialist.value,
                    true,
                    () {
                      aboutMeController.socialistPoliticsSelection(
                          isInsertData: true);
                    },
                  ),
                ],
              ),
              WidgetHelper().sizeBox(height: 10),
              aboutMeDivider(),
              WidgetHelper().sizeBox(height: 20),
              clearView(aboutMeController.isPoliticsSelected.value,
                  StringsNameUtils.politicsRemove, () {
                aboutMeController.politicsSelection(
                    isInsert: true, politics: '');
              }),
              WidgetHelper().sizeBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  ///Politics Click
  politicsClick(BuildContext context) {
    WidgetHelper().showBottomSheetDialog(
        controller: politicsEditingView(context),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.50);
  }

  /// This method is build common view based on expanded value,
  /// if expanded is true the fit inside the scree else it's wrap content
  commonView(BuildContext context, String name, bool isSelected,
      bool isExpanded, onTap) {
    return isExpanded
        ? Expanded(child: commonViewDetails(context, name, isSelected, onTap))
        : commonViewDetails(context, name, isSelected, onTap);
  }

  /// Exercise, zodiac common view design
  commonViewDetails(BuildContext context, String name, bool isSelected, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width / 3,
        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColor.colorPrimary.toColor(),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                )
              : BoxDecoration(
                  border: Border.all(color: AppColor.colorGray.toColor()),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColor.colorWhite.toColor()
                    : AppColor.colorGray.toColor(),
                fontSize: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Exercise, zodiac clear common view design
  clearView(isSelected, buttonTitle, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  color: AppColor.colorPrimary.toColor(),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                )
              : BoxDecoration(
                  border: Border.all(color: AppColor.colorGray.toColor()),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
          child: Center(
            child: Text(
              buttonTitle,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColor.colorWhite.toColor()
                    : AppColor.colorGray.toColor(),
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
