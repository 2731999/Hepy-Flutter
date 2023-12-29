import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/usercards/user_cards_model.dart';
import 'package:hepy/app/modules/home/userdetails/controller/home_card_details_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class HomeCardDetailsView extends GetView<HomeCardDetailsController> {
  HomeCardDetailsController homeCardDetailsController =
      HomeCardDetailsController();

  HomeCardDetailsView({Key? key}) : super(key: key);
  UserCardsModel userDetails = Get.arguments[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                cardContainer(context, homeCardDetailsController),
                userDetailContainer(userDetails)
              ],
            ),
          ),
        ),
        swipeCardControlView(context: context)
      ],
    ));
  }

  cardContainer(BuildContext context,
      HomeCardDetailsController homeCardDetailsController) {
    return Obx(
      () => SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: CarouselSlider(
                carouselController: homeCardDetailsController.controller,
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * 0.8,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      homeCardDetailsController.currentIndex.value = index;
                    }),
                items: userDetails.photos
                    ?.map(
                      (item) => Center(
                        child: Image.network(
                          item,
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.8,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: userDetails.photos!.asMap().entries.map((entry) {
                    return GestureDetector(
                        onTap: () => homeCardDetailsController.controller
                            .animateToPage(entry.key),
                        child: Container(
                            width: 20.0,
                            height: 4.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: homeCardDetailsController
                                          .currentIndex.value ==
                                      entry.key
                                  ? AppColor.colorWhite.toColor()
                                  : AppColor.colorGray.toColor(),
                            )));
                  }).toList(),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () => Get.back(),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Card(
                    margin: const EdgeInsets.only(top: 24, right: 24),
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                    child: Image.asset(
                      ImagePathUtils.collapse_image,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  userDetailContainer(UserCardsModel model) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, top: 16),
      child: Column(
        children: [
          Row(
            children: [
              WidgetHelper().simpleTextWithPrimaryColor(
                  textColor: AppColor.colorText.toColor(),
                  text: '${model.initials}, ',
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              WidgetHelper().simpleTextWithPrimaryColor(
                textColor: AppColor.colorText.toColor(),
                text: model.age.toString(),
                fontSize: 30,
              ),
              WidgetHelper().sizeBox(width: 7),
              Visibility(
                visible: model.verified!,
                child: Image.asset(
                  ImagePathUtils.verified_image,
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
          WidgetHelper().sizeBox(height: 16),
          userDetailView(
              imagePath: ImagePathUtils.person_image,
              userDetails: userDetails.gender),
          WidgetHelper().sizeBox(height: 8),
          userDetails.demographics != null
              ? Column(
                  children: <Widget>[
                    if (userDetails.demographics!.educationLevel != null &&
                        userDetails.demographics!.educationLevel!.isNotEmpty)
                      userDetailView(
                          imagePath: ImagePathUtils.education_image,
                          userDetails:
                              userDetails.demographics?.educationLevel),
                    if (userDetails.demographics!.educationLevel != null &&
                        userDetails.demographics!.educationLevel!.isNotEmpty)
                      WidgetHelper().sizeBox(height: 8),
                    if (userDetails.demographics!.height != null)
                      userDetailView(
                          imagePath: ImagePathUtils.height_image,
                          userDetails:
                              '${userDetails.demographics?.height} cm'),
                    if (userDetails.demographics?.height != null)
                      WidgetHelper().sizeBox(height: 8),
                    if (userDetails.demographics!.zodiac != null &&
                        userDetails.demographics!.zodiac!.isNotEmpty)
                      userDetailView(
                          imagePath: ImagePathUtils.zodiac_image,
                          userDetails: userDetails.demographics?.zodiac),
                    if (userDetails.demographics!.zodiac != null &&
                        userDetails.demographics!.zodiac!.isNotEmpty)
                      WidgetHelper().sizeBox(height: 8),
                    if (userDetails.demographics!.exercise != null &&
                        userDetails.demographics!.exercise!.isNotEmpty)
                      userDetailView(
                          imagePath: ImagePathUtils.exercise_image,
                          userDetails: userDetails.demographics?.exercise),
                    if (userDetails.demographics!.exercise != null &&
                        userDetails.demographics!.exercise!.isNotEmpty)
                      WidgetHelper().sizeBox(height: 8),
                    if (userDetails.demographics!.drinking != null &&
                        userDetails.demographics!.drinking!.isNotEmpty)
                      userDetailView(
                          imagePath: ImagePathUtils.drinking_image,
                          userDetails: userDetails.demographics?.drinking),
                    if (userDetails.demographics!.drinking != null &&
                        userDetails.demographics!.drinking!.isNotEmpty)
                      WidgetHelper().sizeBox(height: 8),
                    if (userDetails.demographics!.smoking != null &&
                        userDetails.demographics!.smoking!.isNotEmpty)
                      userDetailView(
                          imagePath: ImagePathUtils.smoking_image,
                          userDetails: userDetails.demographics?.smoking),
                    if (userDetails.demographics!.smoking != null &&
                        userDetails.demographics!.smoking!.isNotEmpty)
                      WidgetHelper().sizeBox(height: 8),
                    if (userDetails.demographics!.kids != null &&
                        userDetails.demographics!.kids!.isNotEmpty)
                      userDetailView(
                          imagePath: ImagePathUtils.children_image,
                          userDetails: userDetails.demographics?.kids),
                    if (userDetails.demographics!.kids != null &&
                        userDetails.demographics!.kids!.isNotEmpty)
                      WidgetHelper().sizeBox(height: 8),
                    if (userDetails.demographics!.religion != null &&
                        userDetails.demographics!.religion!.isNotEmpty)
                      userDetailView(
                          imagePath: ImagePathUtils.religion_image,
                          userDetails: userDetails.demographics?.religion),
                    if (userDetails.demographics!.religion != null &&
                        userDetails.demographics!.religion!.isNotEmpty)
                      WidgetHelper().sizeBox(height: 8),
                    if (userDetails.demographics?.politics != null &&
                        userDetails.demographics!.politics!.isNotEmpty)
                      userDetailView(
                          imagePath: ImagePathUtils.politics_image,
                          userDetails: userDetails.demographics?.politics),
                    if (userDetails.demographics?.politics != null &&
                        userDetails.demographics!.politics!.isNotEmpty)
                      WidgetHelper().sizeBox(height: 8),
                    userDetailView(
                      imagePath: ImagePathUtils.language_image,
                      userDetails: userDetails.languages?.join(', '),
                    ),
                  ],
                )
              : const SizedBox(),
          WidgetHelper().sizeBox(height: 16),
          InkWell(
            onTap: () async {
              final isUserAlreadyReported =
                  await homeCardDetailsController.isUserAlreadyReported(
                      reportedByUid: model.uid!,
                      reportedUserUid: CommonUtils().auth.currentUser!.uid);
              if (!isUserAlreadyReported) {
                homeCardDetailsController.userReport(model);
              } else {
                WidgetHelper()
                    .showMessage(msg: StringsNameUtils.alreadyReportedUser);
              }
            },
            child: SizedBox(
              child: Column(
                children: [
                  Divider(
                    color: AppColor.colorGray.toColor(),
                  ),
                  WidgetHelper().sizeBox(height: 24),
                  WidgetHelper().simpleTextWithPrimaryColor(
                      textColor: AppColor.colorText.toColor(),
                      text: 'REPORT ${userDetails.initials}',
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis),
                  WidgetHelper().sizeBox(height: 24),
                  Divider(
                    color: AppColor.colorGray.toColor(),
                  ),
                ],
              ),
            ),
          ),
          WidgetHelper().sizeBox(height: 50),
        ],
      ),
    );
  }

  userDetailView({required String imagePath, required dynamic userDetails}) {
    return Visibility(
      visible: userDetails!.isNotEmpty,
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 24,
            height: 24,
          ),
          WidgetHelper().sizeBox(width: 8),
          WidgetHelper().simpleTextWithPrimaryColor(
              textColor: AppColor.colorText.toColor(),
              text: userDetails,
              fontSize: 16,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  swipeCardControlView({required BuildContext context}) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            disLikeView(),
            superLikeView(),
            likeView(),
          ],
        ),
      ),
    );
  }

  likeView() {
    return InkWell(
      onTap: () {
        Get.back(result: [1, userDetails]);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 28),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(ImagePathUtils.like_card_image),
        ),
      ),
    );
  }

  disLikeView() {
    return InkWell(
      onTap: () {
        Get.back(result: [3, userDetails]);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, right: 28),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset(ImagePathUtils.dislike_card_image),
        ),
      ),
    );
  }

  superLikeView() {
    return InkWell(
      onTap: () {
        if (PreferenceUtils.getSuperLikeCount! < 3) {
          Get.back(result: [2, userDetails]);
        } else {
          // Get.back();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: SizedBox(
          width: 40,
          height: 40,
          child: PreferenceUtils.getSuperLikeCount! < 3
              ? Image.asset(
                  ImagePathUtils.superlike_card_image,
                )
              : Image.asset(
                  ImagePathUtils.superlike_card_image,
                  color: AppColor.colorDisabled.toColor(),
                ),
        ),
      ),
    );
  }
}
