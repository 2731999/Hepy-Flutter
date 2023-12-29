import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hepy/app/Database/user_like_dislike_tbl.dart';
import 'package:hepy/app/Utils/api/api_provider.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/enum/card_status.dart';
import 'package:hepy/app/model/conversation/conversation_model.dart';
import 'package:hepy/app/model/usercards/user_cards_model.dart';
import 'package:hepy/app/modules/home/view/home_view.dart';
import 'package:hepy/app/modules/welcome/controller/welcome_controller.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class CardProvider extends ChangeNotifier {
  bool _isDragging = false;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  double _angle = 0;
  bool _isShowUserDetails = false;
  bool _isLoading = false;
  List<UserCardsModel> _lstUserCards = [];
  List<UserCardsModel> _lstRewindCard = [];
  bool isLikeClicked = false;
  bool isDisLikeClicked = false;
  bool isSuperLikeClicked = false;
  bool isBoosterClciked = false;
  bool isRewindClicked = false;
  bool _isLike = false;
  bool _isDisLike = false;
  bool _isSuperLike = false;
  bool isFromRefresh = false;
  UserCardsModel? userCardsModel;
  String _previousCardId = '';
  String _previousConversationId = '';
  bool isPreviousSuperLike = false;
  late ConversationModel? matchConversationModel;
  String _cardStatus = '';

  Offset get position => _position;

  bool get isDragging => _isDragging;

  double get angle => _angle;

  bool get isShowUserDetails => _isShowUserDetails;

  bool get isLoading => _isLoading;

  bool get isFromRefreshValue => isFromRefresh;

  List<UserCardsModel> get lstUserCards => _lstUserCards;

  List<UserCardsModel> get lstRewindCard => _lstRewindCard;

  bool get isLike => _isLike;

  bool get isDisLike => _isDisLike;

  bool get isSuperLike => _isSuperLike;

  Size get screenSize => _screenSize;

  String get previousCardId => _previousCardId;

  String get previousConversationId => _previousConversationId;

  String get cardStatus => _cardStatus;

  set screenSize(Size value) {
    _screenSize = value;
  }

  set previousCardId(String value) {
    _previousCardId = value;
  }

  set previousConversationId(String value) {
    _previousConversationId = value;
  }

  CardProvider() {
    //Todo Temp Comment
    // userCardsAPICall(false);
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    if (!isShowUserDetails) {
      _isDragging = true;
      notifyListeners();
    }
  }

  void setShowUserDetails(bool isShowUserDetails) =>
      _isShowUserDetails = isShowUserDetails;

  void updatePosition(DragUpdateDetails details) {
    if (!isShowUserDetails) {
      _position += details.delta;
      final y = _position.dy;
      final x = _position.dx;
      manageDragStatus(x, y);
      _angle = 20 * x / _screenSize.width;
      if (angle > 2 || angle < -2) {
        notifyListeners();
      } else if (y < 0 &&
          (PreferenceUtils
                      .getStartModelData?.currentSubscriptionPlan?.plan?.id ==
                  3 ||
              PreferenceUtils
                      .getStartModelData?.currentSubscriptionPlan?.plan?.id ==
                  2)) {
        if (PreferenceUtils.getSuperLikeCount! < 3) {
          notifyListeners();
        }
      }
    }
  }

  void endPosition(UserCardsModel userCardsModel, BuildContext context) {
    _isDragging = false;
    if (angle > 2 || angle < -2) {
      notifyListeners();
      manageDrag(
          isClicked: false,
          userCardModel: userCardsModel,
          context: context,
          isFromHomeScreen: true);
    } else if (_position.dy < 0 &&
        (PreferenceUtils.getStartModelData?.currentSubscriptionPlan?.plan?.id ==
                3 ||
            PreferenceUtils
                    .getStartModelData?.currentSubscriptionPlan?.plan?.id ==
                2)) {
      notifyListeners();
      manageDrag(
          isClicked: false,
          userCardModel: userCardsModel,
          context: context,
          isFromHomeScreen: true);
    } else {
      resetPosition();
    }
  }

  /// this method is only used for bottom icon animation
  /// like, dislike or super like icon animation
  manageDragStatus(x, y) {
    x = _position.dx;
    y = _position.dy;
    final forceSuperLike = x.abs() < 20;
    const delta = 20;
    const deltaY = 20;
    dynamic status;
    bool isSuperLike = false;

    /// y is only used to show super like
    if (y < 0) {
      isSuperLike = true;
      _isLike = false;
      _isDisLike = false;
    }
    if (x >= delta && !isSuperLike) {
      status = CardStatus.like;
      _cardStatus = "like";
    } else if (x <= -delta && !isSuperLike) {
      status = CardStatus.dislike;
      _cardStatus = "disLike";
    } else if (y <= -deltaY / 2 &&
        forceSuperLike &&
        (PreferenceUtils.getStartModelData?.currentSubscriptionPlan?.plan?.id ==
                3 ||
            PreferenceUtils
                    .getStartModelData?.currentSubscriptionPlan?.plan?.id ==
                2)) {
      if (PreferenceUtils.getSuperLikeCount! < 3) {
        _isDisLike = false;
        _cardStatus = "superLike";
        status = CardStatus.superLike;
      }
    }
    switch (status) {
      case CardStatus.like:
        _isLike = true;
        _isDisLike = false;
        _isSuperLike = false;
        notifyListeners();
        break;
      case CardStatus.dislike:
        _isDisLike = true;
        _isLike = false;
        _isSuperLike = false;
        notifyListeners();
        break;
      case CardStatus.superLike:
        _isSuperLike = true;
        notifyListeners();
        break;
      default:
        break;
    }
  }

  manageDrag(
      {bool isClicked = false,
      int xPosition = 0,
      int yPosition = 0,
      required UserCardsModel userCardModel,
      required BuildContext context,
      required isFromHomeScreen}) {
    final status = isClicked
        ? getStatus(
            isClicked: isClicked, xPosition: xPosition, yPosition: yPosition)
        : getStatus();
    switch (status) {
      case CardStatus.like:
        like(
            userCardModel: userCardModel,
            context: context,
            isFromHomeScreen: isFromHomeScreen);
        break;
      case CardStatus.dislike:
        dislike(
            userCardModel: userCardModel, isFromHomeScreen: isFromHomeScreen);
        break;
      case CardStatus.superLike:
        superLiker(
            userCardModel: userCardModel,
            isFromHomeScreen: isFromHomeScreen,
            context: context);
        break;
      default:
        resetPosition();
        break;
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;
    _isLike = false;
    _isDisLike = false;
    _isSuperLike = false;
    notifyListeners();
  }

  //todo temp change
  Future<void> userCardsAPICall(bool isReload) async {
    _isLoading = true;
    //Todo Temp Change
    // if (isReload) {
    notifyListeners();
    // }
    String? token = await CommonUtils().auth.currentUser?.getIdToken();
    debugPrint("IdToken ===> $token");
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    apiProvider.get(apiurl: ApiUrl.card, header: header).then((value) {
      if (value.statusCode == 200) {
        var response = jsonDecode(value.body);
        debugPrint("UserCard ===> ${response}");
        _lstUserCards.clear();
        for (var user in response) {
          _lstUserCards.add(UserCardsModel.fromJson(user));
        }
        var lstCards = _lstUserCards.reversed.toList();
        _lstUserCards = lstCards;
        if (isReload && lstCards.isEmpty) {
          isFromRefresh = true;
        } else {
          isFromRefresh = false;
        }
        _isLoading = false;
        notifyListeners();
      } else if (value.statusCode == 404) {
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
        _isLoading = false;
        notifyListeners();
      } else if (value.statusCode == 403) {
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
        _isLoading = false;
        notifyListeners();
      } else if (value.statusCode == 401) {
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  CardStatus? getStatus(
      {bool isClicked = false, int xPosition = 0, int yPosition = 0}) {
    final x, y;
    if (isClicked) {
      x = xPosition;
      y = yPosition;
    } else {
      x = _position.dx;
      y = _position.dy;
    }
    final forceSuperLike = x.abs() < 20;
    const delta = 50;
    if (x >= delta) {
      return CardStatus.like;
    } else if (x <= -delta) {
      return CardStatus.dislike;
    } else if (y <= -delta / 2 &&
        forceSuperLike &&
        (PreferenceUtils.getStartModelData?.currentSubscriptionPlan?.plan?.id ==
                3 ||
            PreferenceUtils
                    .getStartModelData?.currentSubscriptionPlan?.plan?.id ==
                2)) {
      if (PreferenceUtils.getSuperLikeCount! < 3) {
        return CardStatus.superLike;
      }
    }
  }

  void like(
      {required UserCardsModel userCardModel,
      required BuildContext context,
      required isFromHomeScreen}) async {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    if (PreferenceUtils.getStartModelData?.currentSubscriptionPlan?.plan?.id ==
        1) {
      if (PreferenceUtils.getTodayLike! <= PreferenceUtils.getLikePerDay! - 1) {
        insertLikeDisLikeAndSuperLikeInToDb(
            cardUserId: userCardModel.uid,
            likingStatus: 1,
            userCardsModel: userCardModel,
            previousCardId: previousCardId,
            previousConversationId: previousConversationId,
            isFromHomeScreen: isFromHomeScreen);

        isPreviousSuperLike = false;
        swipeData();
        _nextCard(userCardModel: userCardModel);
        showProfileMatchDialog(userCardsModel, context, 1);
        isLikeClicked = false;
        notifyListeners();
      } else {
        resetPosition();
        HomeView homeView = HomeView();
        homeView.showSubscriptionDialog(context, false, true, true);
      }
    } else {
      insertLikeDisLikeAndSuperLikeInToDb(
          cardUserId: userCardModel.uid,
          likingStatus: 1,
          userCardsModel: userCardModel,
          previousCardId: previousCardId,
          previousConversationId: previousConversationId,
          isFromHomeScreen: isFromHomeScreen);

      isPreviousSuperLike = false;
      swipeData();
      _nextCard(userCardModel: userCardModel);
      //todo temp comment
      /*if (matchConversationModel?.id != null &&
          matchConversationModel?.p1 != null) {*/
      showProfileMatchDialog(userCardsModel, context, 1);
      //}
      isLikeClicked = false;
      notifyListeners();
    }
  }

  void _nextCard({required UserCardsModel userCardModel}) async {
    if (_lstUserCards.isEmpty) return;
    //todo temp change
    // await Future.delayed(const Duration(milliseconds: 200));
    _lstUserCards.removeLast();
    addToRewindList(userCardModel: userCardModel);
    resetPosition();
  }

  // todo temp change
  Future<void> dislike(
      {required UserCardsModel userCardModel,
      required isFromHomeScreen}) async {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    isPreviousSuperLike = false;
    isDisLikeClicked = false;
    swipeData();
    _nextCard(userCardModel: userCardModel);
    insertLikeDisLikeAndSuperLikeInToDb(
        cardUserId: userCardModel.uid,
        likingStatus: 3,
        userCardsModel: userCardModel,
        previousCardId: previousCardId,
        previousConversationId: previousConversationId,
        isFromHomeScreen: isFromHomeScreen);
    // notifyListeners();
  }

  void superLiker(
      {required UserCardsModel userCardModel,
      required isFromHomeScreen,
      required BuildContext context}) async {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    if (PreferenceUtils.isSuperLike) {
      insertLikeDisLikeAndSuperLikeInToDb(
          cardUserId: userCardModel.uid,
          likingStatus: 2,
          userCardsModel: userCardModel,
          previousCardId: previousCardId,
          previousConversationId: previousConversationId,
          isFromHomeScreen: isFromHomeScreen);
      superLikeNotification(uid: userCardsModel?.uid);
      isPreviousSuperLike = true;
      isSuperLikeClicked = false;
      increaseSuperLike();
      swipeData();
      _nextCard(userCardModel: userCardModel);
      showProfileMatchDialog(userCardsModel, context, 2);
      // notifyListeners();
    } else {
      resetPosition();
      HomeView homeView = HomeView();
      if (PreferenceUtils.getSuperLikeCount! < 1) {
        homeView.showSubscriptionDialog(context, false, true, true);
      } else {
        homeView.showSubscriptionDialog(context, false, false, true);
      }
    }
  }

  /// This method add like, dislike and superLike
  /// data into database.
  Future<void> insertLikeDisLikeAndSuperLikeInToDb(
      {required cardUserId,
      required likingStatus,
      required UserCardsModel userCardsModel,
      String previousCardId = '',
      String previousConversationId = '',
      required isFromHomeScreen}) async {
    await UserLikeDisLikeTbl().insertLikeAndDislikeData(
        thisUserId: CommonUtils().auth.currentUser!.uid,
        otherUserId: cardUserId,
        likingStatus: likingStatus,
        userCardsModel: userCardsModel,
        previousCardId: previousCardId,
        previousConversationId: previousConversationId,
        isFromHomeScreen: isFromHomeScreen);
    if (_previousCardId.isNotEmpty) {
      _previousCardId = '';
    }
  }

  /// This method is save swipe count locally
  /// it will update when app restart
  void swipeData() {
    int? planId =
        PreferenceUtils.getStartModelData?.currentSubscriptionPlan?.plan?.id;
    switch (planId) {
      case 1:
        if (PreferenceUtils.getTodayLike != null) {
          PreferenceUtils.setTodayLike = PreferenceUtils.getTodayLike! + 1;
        }
        break;
    }
  }

  /// This method is increase super like base on plan id
  /// gold and platinum member only used super like feature.
  void increaseSuperLike() {
    int? planId =
        PreferenceUtils.getStartModelData?.currentSubscriptionPlan?.plan?.id;

    if (PreferenceUtils.getSuperLikeCount != null) {
      PreferenceUtils.setSuperLikeCount =
          PreferenceUtils.getSuperLikeCount! + 1;
    }
    WelcomeController welcomeController = WelcomeController();
    if (planId == 2) {
      welcomeController.manageSuperLike(2);
    } else if (planId == 3) {
      welcomeController.manageSuperLike(3);
    }
  }

  /// This method is used to undo swipe count
  /// this feature is only available for platinum user
  void rewindSwipe() {
    if (PreferenceUtils.getTodayLike != null) {
      PreferenceUtils.setTodayLike = PreferenceUtils.getTodayLike! - 1;
    }
    if (isPreviousSuperLike) {
      PreferenceUtils.setSuperLikeCount = PreferenceUtils.getTodayLike! - 1;
      isPreviousSuperLike = false;
    }
  }

  /// After like, dislike or superlike card data will add in rewind list.
  /// rewind list is work only in platinum user
  void addToRewindList({required UserCardsModel userCardModel}) {
    _lstRewindCard.clear();
    _lstRewindCard.add(userCardModel);
  }

  /// when user click on rewind button,
  /// last added card will add again into main list
  /// and update main list
  addRewindToMainList() {
    if (_lstRewindCard.isNotEmpty) {
      _lstUserCards.add(_lstRewindCard.last);
      _lstRewindCard.removeLast();
      rewindSwipe();
      isRewindClicked = false;
      notifyListeners();
    }
  }

  void showProfileMatchDialog(
      UserCardsModel? userCardsModel, BuildContext context, int likingStatus) {
    if (userCardsModel?.liked != null && userCardsModel?.liked == 1 ||
        userCardsModel?.liked == 2) {
      profileMatchDialog(
          matchedName: userCardsModel?.initials,
          matchUrl: userCardsModel?.thumbnail,
          myPic: PreferenceUtils.getStartModelData?.thumbnail,
          context: context,
          userCardsModel: userCardsModel,
          likingStatus: likingStatus);
      profileMatchNotification(uid: userCardsModel?.uid);
    }
  }

  profileMatchDialog(
      {required String? matchedName,
      required String? matchUrl,
      required String? myPic,
      required BuildContext context,
      required UserCardsModel? userCardsModel,
      required int likingStatus}) {
    WidgetHelper().profileMatchDialog(
        context, matchedName, matchUrl, myPic, userCardsModel, likingStatus);
  }

  /// This method is send notification for superLike
  void superLikeNotification({required String? uid}) async {
    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();
    debugPrint('deleteAccount ===>  token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    requestParams = {
      'userId': uid,
    };
    apiProvider
        .post(
            apiurl: ApiUrl.superLikeNotification,
            header: header,
            body: requestParams)
        .then(
      (value) {
        if (value.statusCode == 200) {
        } else if (value.statusCode == 404) {
          WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
        } else if (value.statusCode == 403) {
          WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
        } else if (value.statusCode == 401) {
          WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        }
      },
    );
  }

  /// This method is send notification for superLike
  void profileMatchNotification({required String? uid}) async {
    final auth = FirebaseAuth.instance;
    String? token = await auth.currentUser?.getIdToken();
    debugPrint('deleteAccount ===>  token $token');
    ApiProvider apiProvider = ApiProvider();
    Map<String, String>? header = <String, String>{};
    Map<String, dynamic>? requestParams = <String, dynamic>{};
    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
    requestParams = {
      'userId': uid,
    };
    apiProvider
        .post(
            apiurl: ApiUrl.matchNotification,
            header: header,
            body: requestParams)
        .then(
      (value) {
        if (value.statusCode == 200) {
        } else if (value.statusCode == 404) {
          WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
        } else if (value.statusCode == 403) {
          WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
        } else if (value.statusCode == 401) {
          WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
        }
      },
    );
  }

  afterInAppPurchaseUpdateView() {
    notifyListeners();
  }
}
