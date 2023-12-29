import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:hepy/app/Utils/app_color.dart';
import 'package:hepy/app/Utils/extensions.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/model/usercards/user_cards_model.dart';
import 'package:hepy/app/modules/home/view/home_view.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/swipecards/card_provider.dart';
import 'package:hepy/app/widgets/swipecards/tag_widget.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:provider/provider.dart';

class SwipeCard extends StatefulWidget {
  final UserCardsModel userCardsModel;
  final bool isFront;

  const SwipeCard(
      {Key? key, required this.userCardsModel, required this.isFront})
      : super(key: key);

  @override
  State<SwipeCard> createState() => _SwipeCardState();
}

class _SwipeCardState extends State<SwipeCard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: widget.isFront ? buildFrontCard() : buildCard(),
      );

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = Provider.of<CardProvider>(context);
            final position = provider.position;
            final millisecond = provider.isDragging ? 0 : 400;
            final isShowUserDetails = provider.isShowUserDetails;
            provider.userCardsModel = widget.userCardsModel;
            String status = provider.cardStatus;

            final center = constraints.smallest.center(Offset.zero);
            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);

            debugPrint("Card Position ===> $status");

            return AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(microseconds: millisecond),
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: buildCard(
                  position: position.dy < 0 ? position.dy : position.dx,
                  isSuperLike: PreferenceUtils.isSuperLike
                      ? position.dy < 0
                          ? true
                          : false
                      : false,
                  isShowUserDetails: isShowUserDetails,
                  cardStatus: status),
            );
          },
        ),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition(widget.userCardsModel, context);
        },
      );

  Widget buildCard(
          {dynamic position = 0,
          bool isSuperLike = false,
          bool isShowUserDetails = false,
          String cardStatus = ''}) =>
      Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: AppColor.colorWhite.toColor(),
              image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      widget.userCardsModel.photos!.isNotEmpty
                          ? widget.userCardsModel.photos![0]
                          : ""),
                  fit: BoxFit.cover,
                  alignment: const Alignment(-0.3, 0)),
            ),
          ),
          cardDataContainer(isShowUserDetails, context),

          /// Based on user action we will display like, nope and superLike
          /// if position is grater 70 pixel and superLike is false, then it will display LIKE
          /// if position is grater -70 pixel and superLike is false, then it will display NOPE
          /// if position is grater -70 pixel and superLike is true, then it will display SUPERLIKE
          /// default pixel is 0 and isSuperLike is false, then tag view is hide.
          if (cardStatus == 'like' && position > 70)
            Positioned(
              top: 40,
              left: 20,
              child: Transform.rotate(
                angle: 12,
                child: TagWidget(
                  text: 'LIKE',
                  color: AppColor.likeColor.toColor(),
                ),
              ),
            ),
          if (cardStatus == 'disLike' && position < -70)
            Positioned(
              top: 40,
              right: 24,
              child: Transform.rotate(
                angle: -12,
                child: TagWidget(
                  text: 'NOPE',
                  color: AppColor.nopeColor.toColor(),
                ),
              ),
            ),
          if (cardStatus == 'superLike' && position < -70)
            Positioned(
              bottom: 200,
              right: 120,
              child: Transform.rotate(
                angle: 12,
                child: TagWidget(
                  text: 'Super\nLike',
                  color: AppColor.superLikeColor.toColor(),
                ),
              ),
            )
        ],
      );

  cardDataContainer(bool isShowUserDetails, BuildContext context) {
    return !isShowUserDetails
        ? Container(
            alignment: Alignment.bottomLeft,
            margin: const EdgeInsets.only(bottom: 80, left: 20),
            child: Row(
              children: [
                WidgetHelper().simpleTextWithPrimaryColor(
                    textColor: AppColor.colorWhite.toColor(),
                    text: '${widget.userCardsModel.initials}, ',
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                WidgetHelper().simpleTextWithPrimaryColor(
                  textColor: AppColor.colorWhite.toColor(),
                  text: widget.userCardsModel.age.toString(),
                  fontSize: 30,
                ),
                WidgetHelper().sizeBox(width: 7),
                Visibility(
                  visible: widget.userCardsModel.verified!,
                  child: Image.asset(
                    ImagePathUtils.verified_image,
                    width: 24,
                    height: 24,
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    var value = await Get.toNamed(Routes.USERCARDSDETAILS,
                        arguments: [widget.userCardsModel]);

                    ///OnActivity Result
                    manageLikeDesLikeAndSuperLikeFromUserDetailPage(
                        value[0], value[1], context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 25),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(ImagePathUtils.info_image,
                        width: 24, height: 24),
                  ),
                )
              ],
            ),
          )
        : Container();
  }

  /// when user click on like, dislike and super like, it will
  /// back to the home screen with previous screen value
  /// 1 = like
  /// 2 = superlike
  /// 3 = dislike
  manageLikeDesLikeAndSuperLikeFromUserDetailPage(
      int value, UserCardsModel userCardsModel, BuildContext context) {
    final provider = Provider.of<CardProvider>(context, listen: false);
    switch (value) {
      case 1:
        provider.manageDrag(
            isClicked: true,
            xPosition: 101,
            yPosition: 0,
            userCardModel: provider.userCardsModel!,
            context: context,
            isFromHomeScreen: true);
        break;
      case 2:
        if (PreferenceUtils.isSuperLike) {
          provider.manageDrag(
              isClicked: true,
              xPosition: 0,
              yPosition: -50,
              userCardModel: provider.userCardsModel!,
              context: context,
              isFromHomeScreen: true);
        } else {
          HomeView homeView = HomeView();
          if (PreferenceUtils.getSuperLikeCount! < 1) {
            homeView.showSubscriptionDialog(context, false, true, true);
          } else {
            homeView.showSubscriptionDialog(context, false, false, true);
          }
        }

        break;
      case 3:
        provider.manageDrag(
            isClicked: true,
            xPosition: -101,
            yPosition: 0,
            userCardModel: provider.userCardsModel!,
            context: context,
            isFromHomeScreen: true);
        break;
    }
  }
}
