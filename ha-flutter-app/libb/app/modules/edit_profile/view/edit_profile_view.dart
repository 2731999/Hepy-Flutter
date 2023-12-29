import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/dialogs_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/modules/aboutme/controller/about_me_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

import '../../../Utils/app_color.dart';
import '../../../Utils/image_path_utils.dart';
import '../../../widgets/reorder_grid.dart';
import '../../add_language/controller/add_language_controller.dart';
import '../../add_more_photos/controller/add_more_photos_controller.dart';
import '../controller/edit_profile_controller.dart';

class EditProfileView extends GetView<AddMorePhotosController> {
  AddMorePhotosController addMorePhotosController = AddMorePhotosController();
  AboutMeController aboutMeController = AboutMeController();
  EditProfileController editProfileController = EditProfileController();
  AddLanguageController addLanguageController = AddLanguageController();

  int variableSet = 0;

  EditProfileView({Key? key}) : super(key: key);

  Future<bool> _onWillPop() async {
    Get.back(result: true);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    if (!aboutMeController.heightFocus.value) {
      aboutMeController.heightFocus.value = true;
      editProfileController.getData(
          addMorePhotosController, aboutMeController, addLanguageController);
    }
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Obx(
        () => addMorePhotosController.isLoading.value
            ? Container(
                color: AppColor.colorWhite.toColor(),
                child: const Center(child: CircularProgressIndicator()),
              )
            : Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: WidgetHelper().showAppBarText(title: StringsNameUtils.editProfileTitle,
                  onDone: () {
                    Get.back();
                  },
                ),
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      profileImages(context),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 332,
                        child: WidgetHelper().simpleText(
                            text: StringsNameUtils.aboutMe,
                            fontSize: 24,
                            textAlign: TextAlign.left),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(child: aboutMeList(context)),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 332,
                        child: WidgetHelper().simpleText(
                            text: StringsNameUtils.languageTitle,
                            fontSize: 24,
                            textAlign: TextAlign.left),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Flexible(child: languagesView(context))
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget languagesView(context) {
    return Obx(
      () => Container(
        color: AppColor.colorWhite.toColor(),
        child: Column(
          children: [
            ListView.builder(
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount:
                    addLanguageController.lstSelectedLanguage.value.length,
                itemBuilder: (context, index) {
                  var selectedLanguage =
                      addLanguageController.lstSelectedLanguage.value[index];
                  return selectedLanguageItemView(selectedLanguage);
                }),
            WidgetHelper().sizeBox(height: 5),
            InkWell(
              onTap: () {
                if (addLanguageController.lstSelectedLanguage.value.length <
                    5) {
                  addLanguageController.lstLanguages.clear();
                  addLanguageController.addLanguageToList();
                  WidgetHelper().showBottomSheetDialog(
                      controller: showLanguageSelectionView(context),
                      bottomSheetHeight:
                          MediaQuery.of(context).size.height * 0.95);
                } else {
                  WidgetHelper()
                      .showMessage(msg: StringsNameUtils.maxLanguageMessage);
                }
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 15, top: 5, bottom: 5, right: 15),
                  child: WidgetHelper().simpleTextWithPrimaryColor(
                      text: StringsNameUtils.addLanguage,
                      textAlign: TextAlign.left,
                      textColor: AppColor.colorPrimary.toColor(),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            WidgetHelper().sizeBox(height: 20),
          ],
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
        addLanguageController.editSelectedLanguageToDB(isFromLanguage: false);
      },
      child: Container(
        color: AppColor.colorWhite.toColor(),
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
              addLanguageController.lstSelectedLanguage.value.length != 1
                  ? GestureDetector(
                      onTap: () {
                        addLanguageController.removeLanguageAsSelectedLanguage(
                            language: language);
                        addLanguageController.editSelectedLanguageToDB(
                            isFromLanguage: false);
                      },
                      child: Image.asset(
                        ImagePathUtils.close_image,
                        width: 25,
                        height: 25,
                      ),
                    )
                  : const SizedBox(
                      height: 25,
                      width: 25,
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

  Widget aboutMeList(context) {
    return Column(
      children: [
        aboutMeCommonView(
          StringsNameUtils.height,
          aboutMeController.height.value != null &&
                  aboutMeController.height.value.isNotEmpty
              ? '${aboutMeController.height.value} cm'
              : '',
          () {
            heightClick(context);
            //exerciseClick(context);
          },
        ),
        aboutMeCommonView(
          StringsNameUtils.exercise,
          aboutMeController.exercise.value,
          () {
            exerciseClick(context);
            // aboutMeClick(context, StringsNameUtils.exercise);
          },
        ),
        aboutMeCommonView(
          StringsNameUtils.zodiac,
          aboutMeController.zodiac.value,
          () {
            zodiacClick(context);
          },
        ),
        aboutMeCommonView(
          StringsNameUtils.educationLevel,
          aboutMeController.educationLevel.value,
          () {
            educationLevelClick(context);
          },
        ),
        aboutMeCommonView(
          StringsNameUtils.drinking,
          aboutMeController.drinking.value,
          () {
            drinkingClick(context);
          },
        ),
        aboutMeCommonView(
          StringsNameUtils.smoking,
          aboutMeController.smoking.value,
          () {
            smokingClick(context);
          },
        ),
        aboutMeCommonView(
          StringsNameUtils.kids,
          aboutMeController.kids.value,
          () {
            kidsClick(context);
          },
        ),
        aboutMeCommonView(
          StringsNameUtils.religion,
          aboutMeController.religion.value,
          () {
            religionClick(context);
          },
        ),
        aboutMeCommonView(
          StringsNameUtils.politics,
          aboutMeController.politics.value,
          () {
            politicsClick(context);
          },
        ),
      ],
    );
  }

  ///AboutMe View
  aboutMeCommonView(String aboutMeName, String aboutMeValue, onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColor.colorWhite.toColor(),
        child: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: WidgetHelper().simpleText(
                          text: aboutMeName, textAlign: TextAlign.start),
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
              Divider(color: AppColor.colorGray.toColor())
            ],
          ),
        ),
      ),
    );
  }

  Widget profileImages(context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        children: [
          ReorderableGridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: imageListView(context),
            onReorder: (oldIndex, newIndex) {
              if (newIndex < addMorePhotosController.lstUserPhotos.length) {
                if (oldIndex == newIndex) {
                  newIndex -= 1;
                }
                addMorePhotosController.lstUserPhotos.value.insert(
                    newIndex,
                    addMorePhotosController.lstUserPhotos.value
                        .removeAt(oldIndex));
                addMorePhotosController.uploadPhotosIndex(
                    isShowProgress: true,
                    list: addMorePhotosController.lstUserPhotos.value);
              }
            },
          ),
        ],
      ),
    );
  }

  List<Widget> imageListView(BuildContext context) {
    var userGroup = <Widget>[];
    for (var index = 0; index < 8; index++) {
      userGroup.add(
        emptyImageView(
          context: context,
          imagePath: addMorePhotosController.lstUserPhotos.value.length > index
              ? addMorePhotosController.lstUserPhotos.value[index].thumb!.url!
              : "",
          imageNo: index,
          isShowProgress:
              addMorePhotosController.showProgressIndexList.value[index]
                  ? true
                  : false,
          verified: addMorePhotosController.lstUserPhotos.value.length > index
              ? addMorePhotosController.lstUserPhotos.value[index].isVerified ??
                  false
              : false,
          photoId: addMorePhotosController.lstUserPhotos.value.length > index
              ? addMorePhotosController.lstUserPhotos.value[index].id
              : "",
        ),
      );
    }
    return userGroup;
  }

  Widget emptyImageView(
      {required BuildContext context,
      required String imagePath,
      required int imageNo,
      required bool isShowProgress,
      required bool verified,
      String? photoId = ''}) {
    return imagePath.isEmpty
        ? Material(
            key: ValueKey(imageNo),
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                selectionClick(context, imagePath, imageNo, verified, photoId);
              },
              child: Stack(children: [
                Positioned.fill(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 130,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColor.colorGray.toColor(), width: 2),
                    ),
                    child: Center(
                      child: isShowProgress
                          ? CircularProgressIndicator(
                              color: AppColor.colorPrimary.toColor(),
                            )
                          : WidgetHelper().simpleTextWithPrimaryColor(
                              textColor: AppColor.colorPrimary.toColor(),
                              text: "+",
                              fontSize: 36,
                            ),
                    ),
                  ),
                ),
              ]),
            ),
          )
        : Container(
            key: ValueKey(imageNo),
            color: Colors.transparent,
            child: Stack(
              //key: ValueKey(imageNo),
              children: [
                Obx(
                  () => Positioned.fill(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.70,
                      height: 130,
                      margin: const EdgeInsets.all(5),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColor.colorPrimary.toColor(), width: 2),
                      ),
                      child: Center(
                        child: addMorePhotosController
                                .showProgressIndexList.value[imageNo]
                            ? CircularProgressIndicator(
                                color: AppColor.colorPrimary.toColor(),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(imagePath),
                                      fit: BoxFit.cover),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                //   addMorePhotosController.lstUserPhotos.value[imageNo].isVerified!
                /*Obx(
                  () =>*/
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width / 2,
                  height: 140,
                  margin: const EdgeInsets.only(top: 27, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: addMorePhotosController
                                .lstUserPhotos.value[imageNo].isVerified!
                            ? Image.asset(
                                ImagePathUtils.verified_image,
                                width: 35,
                                height: 35,
                              )
                            : Container(),
                      ),
                    ],
                  ),
                ),
                // ),
                //   : Container(),
                /*Obx(
                  () =>*/
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      selectionClick(
                          context, imagePath, imageNo, verified, photoId);
                    },
                    child: Visibility(
                      visible: true,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.70,
                        margin: const EdgeInsets.only(left: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Image.asset(
                                addMorePhotosController
                                            .lstUserPhotos.value.length <
                                        3
                                    ? ImagePathUtils.edit_image
                                    : ImagePathUtils.delete_image,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                //  ),
              ],
            ),
          );
  }

  selectionClick(BuildContext context, String imagePath, int imageNo,
      bool verified, String? photoId) {
    if (photoId!.isEmpty) {
      WidgetHelper().showBottomSheetDialog(
          controller: DialogsUtils.openCameraAndGallerySelectionDialog(
              context, imagePath, imageNo, photoId, addMorePhotosController),
          bottomSheetHeight: 0.0);
    } else {
      WidgetHelper().showBottomSheetDialog(
          controller: addMorePhotosController.lstUserPhotos.value.length < 3
              ? DialogsUtils.openReplaceImageDialog(context, imagePath, photoId,
                  imageNo, verified, addMorePhotosController)
              : DialogsUtils.openDeleteImageDialog(context, imagePath, photoId,
                  verified, addMorePhotosController),
          bottomSheetHeight: 0.0);
    }
  }

  Widget emptyImageViewTemp(
      {required BuildContext context,
      required String imagePath,
      required int imageNo,
      required bool isShowProgress,
      required bool verified,
      String? photoId = ''}) {
    return InkWell(
      onTap: () {
        selectionClick(context, imagePath, imageNo, verified, photoId);
      },
      child: imagePath.isEmpty
          ? Stack(children: [
              Positioned.fill(
                child: Container(
                  width: MediaQuery.of(context).size.width / 3,
                  height: 130,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColor.colorGray.toColor(), width: 2),
                  ),
                  child: Center(
                    child: isShowProgress
                        ? CircularProgressIndicator(
                            color: AppColor.colorPrimary.toColor(),
                          )
                        : WidgetHelper().simpleTextWithPrimaryColor(
                            textColor: AppColor.colorPrimary.toColor(),
                            text: "+",
                            fontSize: 36,
                          ),
                  ),
                ),
              ),
            ])
          : Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.70,
                    height: 130,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColor.colorPrimary.toColor(), width: 2),
                    ),
                    child: Center(
                      child: isShowProgress
                          ? CircularProgressIndicator(
                              color: AppColor.colorPrimary.toColor(),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: NetworkImage(imagePath),
                                    fit: BoxFit.cover),
                              ),
                            ),
                    ),
                  ),
                ),
                addMorePhotosController.lstUserPhotos.value[imageNo].isVerified!
                    ? Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 140,
                        margin: const EdgeInsets.only(top: 25, right: 7),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10),
                              child: Image.asset(
                                ImagePathUtils.verified_image,
                                width: 35,
                                height: 35,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                Visibility(
                  visible: true,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    margin: const EdgeInsets.only(left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Image.asset(
                            addMorePhotosController.lstUserPhotos.value.length <
                                    3
                                ? ImagePathUtils.edit_image
                                : ImagePathUtils.delete_image,
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
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
    return Obx(
      () => SingleChildScrollView(
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
              FocusScope(
                child: Focus(
                  onFocusChange: (focus) => () {
                    aboutMeController.heightFocus.value = focus;
                    print("focus----------------------------------: $focus");
                  },
                  child: WidgetHelper().textField(
                      controller: aboutMeController.heightController.value,
                      hint: StringsNameUtils.heightContentHint,
                      isEnabled: true,
                      isShowLabel: false,
                      textAlign: TextAlign.center,
                      textColor: AppColor.colorText.toColor(),
                      keyboardType: TextInputType.number,
                      isFocusable: true),
                ),
              ),
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
                },
              ),
              WidgetHelper().sizeBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  ///Aboutme
  aboutMeClick(BuildContext context, String key) {
    WidgetHelper().showBottomSheetDialog(
        controller:
            aboutMeEditingView(context, aboutMeController.getList(key), key),
        bottomSheetHeight: MediaQuery.of(context).size.height * 0.60);
  }

  Widget _buildBody(BuildContext context, String key, List<String> list) {
    return Obx(
      () => Wrap(
        direction: Axis.horizontal,
        children: list.map(
          (item) {
            return Container(
              margin: const EdgeInsets.only(right: 5),
              child: Flexible(
                child: aboutMeController.selectedValue.value == item
                    ? FilterChip(
                        label: Text(
                          item,
                          style: const TextStyle(color: Colors.white),
                        ),
                        selected: false,
                        selectedColor: AppColor.colorPrimary.toColor(),
                        backgroundColor: AppColor.colorPrimary.toColor(),
                        shape: const StadiumBorder(side: BorderSide.none),
                        onSelected: (bool value) {
                          aboutMeController.setSelected(key, item, list);
                        },
                      )
                    : FilterChip(
                        label: Text(
                          item,
                          style: TextStyle(color: AppColor.colorGray.toColor()),
                        ),
                        selected: false,
                        backgroundColor: AppColor.colorWhite.toColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(
                            color: AppColor.colorGray.toColor(),
                          ),
                        ),
                        onSelected: (bool value) {
                          aboutMeController.setSelected(key, item, list);
                        },
                      ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  aboutMeEditingView(context, List<String> list, String key) {
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
                  .titleTextView(titleText: aboutMeController.getTitle(key)),
              WidgetHelper().sizeBox(height: 20),
              WidgetHelper().simpleText(
                  text: aboutMeController.getSubTitle(key),
                  textAlign: TextAlign.center),
              WidgetHelper().sizeBox(height: 40),
              // _buildBody1(context, key),
              _buildBody(context, key, list),

              WidgetHelper().sizeBox(height: 10),
              aboutMeDivider(),
              WidgetHelper().sizeBox(height: 20),

              clearView(aboutMeController.isExerciseSelected.value,
                  StringsNameUtils.exerciseRemove, () {
                aboutMeController.setSelected(
                    key, "", aboutMeController.getList(key));
              }),
              WidgetHelper().sizeBox(height: 10),
            ],
          ),
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class FirstDisabledFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}
