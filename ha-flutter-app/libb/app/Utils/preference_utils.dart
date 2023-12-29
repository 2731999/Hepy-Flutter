import 'package:get_storage/get_storage.dart';
import 'package:hepy/app/model/start/start_model.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app_config.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PreferenceUtils {
  PreferenceUtils._private();

  static PreferenceUtils get of => PreferenceUtils._private();

  static const String CURRENT_USER_ID = 'currentUserId';
  static const String SIGNUP_STATUS = 'signUpStatus';
  static const String USER_DATA = 'userData';
  static const String USER_NEW_DATA = 'userNewData';
  static const String ID_TOKEN = 'idToken';
  static const String START_DATA = 'startData';
  static const String SWIPE_PER_DAY = 'swipePerDay';
  static const String TODAY_SWIPE = 'todaySwipe';
  static const String SUPERLIKE = 'superLike';
  static const String REWINDDATA = 'rewindData';
  static const String BOOSTUSER = 'boostUser';
  static const String CURRENTPLAN = 'currentPlan';
  static const String SWIPEPERMONTH = 'swipePerMonth';
  static const String MONTHSWIPE = 'monthSwipe';
  static const String SUPERLIKECOUNT = 'superLikeCount';
  static const String PREVIOUS_CARD_ID = 'previousCardId';
  static const String PREVIOUS_CONVERSATION_ID = 'previousConversationId';
  static const String ISFIRSTTIMEOPEN = 'isAppFirstTimeOpen';
  static const String TODAYCHATDATE = 'todayChatDate';
  static const String ISCURRENTCHATCONVERSATIONSCREEN = 'isCurrentChatConversationScreen';
  static const String OLD_PURCHASE = "oldPurchase";
  static const String CONVERSATION_ID = "conversationId";
  static const String APP_CONFIG = "appConfig";

  static set setCurrentUserId(String currentUid) {
    GetStorage().write(CURRENT_USER_ID, currentUid);
  }

  static String get getCurrentUserId => GetStorage().read(CURRENT_USER_ID) ?? '';

  static set setAppConfig(AppConfig appConfig) {
    GetStorage().write(APP_CONFIG, appConfig);
  }

  static AppConfig get getAppConfig => GetStorage().read(APP_CONFIG);


  static set setSignUpStatus(String signupStatus) {
    GetStorage().write(SIGNUP_STATUS, signupStatus);
  }

  static String get getSignUpStatus => GetStorage().read(SIGNUP_STATUS) ?? '-1';

  static set setUserModelData(UserNewModel user) {
    GetStorage().write(USER_NEW_DATA, user);
  }

  static UserNewModel? get getNewModelData => GetStorage().read(USER_NEW_DATA);

  static set setStartModelData(StartModel startModel) {
    GetStorage().write(START_DATA, startModel);
  }

  static set setOldPurchaseDetails(PurchaseDetails purchaseDetails){
    GetStorage().write(OLD_PURCHASE, purchaseDetails);
  }

  static PurchaseDetails? get getOldPurchaseDetails => GetStorage().read(OLD_PURCHASE);

  static StartModel? get getStartModelData => GetStorage().read(START_DATA);

  static set setLikePerDay(int? swipePerDay) {
    GetStorage().write(SWIPE_PER_DAY, swipePerDay);
  }

  static int? get getLikePerDay => GetStorage().read(SWIPE_PER_DAY);

  static set setTodayLike(int? todaySwipe) {
    GetStorage().write(TODAY_SWIPE, todaySwipe);
  }

  static int? get getTodayLike => GetStorage().read(TODAY_SWIPE);

  static set setSwipePerMonth(int? swipePerMonth) {
    GetStorage().write(SWIPEPERMONTH, swipePerMonth);
  }

  static int? get getSwipePerMonth => GetStorage().read(SWIPEPERMONTH);

  static set setMothSwipe(int? monthSwipe) {
    GetStorage().write(MONTHSWIPE, monthSwipe);
  }

  static int? get getMonthSwipe => GetStorage().read(MONTHSWIPE);

  static set setSuperLikeCount(int? superLikeCount) {
    GetStorage().write(SUPERLIKECOUNT, superLikeCount);
  }

  static int? get getSuperLikeCount => GetStorage().read(SUPERLIKECOUNT);

  static set setSuperLike(bool? isSuperLike) {
    if (isSuperLike == null) {
      GetStorage().write(SUPERLIKE, false);
    } else {
      GetStorage().write(SUPERLIKE, isSuperLike);
    }
  }

  static bool get isSuperLike => GetStorage().read(SUPERLIKE);

  static set setRewindData(bool? isRewindData) {
    if (isRewindData == null) {
      GetStorage().write(REWINDDATA, false);
    } else {
      GetStorage().write(REWINDDATA, isRewindData);
    }
  }

  static bool get isRewindData => GetStorage().read(REWINDDATA);

  static set setBoostUser(bool? isBoostUser) {
    if (isBoostUser == null) {
      GetStorage().write(BOOSTUSER, false);
    } else {
      GetStorage().write(BOOSTUSER, isBoostUser);
    }
  }

  static bool get isBoostUser => GetStorage().read(BOOSTUSER);

  static set setPreviousCardId(String previousCardId) {
    GetStorage().write(PREVIOUS_CARD_ID, previousCardId);
  }

  static String get getPreviousCardId =>
      GetStorage().read(PREVIOUS_CARD_ID) ?? '';

  static set setPreviousConversationId(String previousConversationId) {
    GetStorage().write(PREVIOUS_CONVERSATION_ID, previousConversationId);
  }

  static String get getPreviousConversationId =>
      GetStorage().read(PREVIOUS_CONVERSATION_ID) ?? '';

  static set isOpenFirstTime(bool? isOpenFirstTime) {
    if (isOpenFirstTime == null) {
      GetStorage().write(ISFIRSTTIMEOPEN, true);
    } else {
      GetStorage().write(ISFIRSTTIMEOPEN, isOpenFirstTime);
    }
  }

  static bool get isOpenFirstTime => GetStorage().read(ISFIRSTTIMEOPEN) ?? true;

  static set isCurrentChatConversationScreen(bool? isChatConversationScreen) {
    if (isChatConversationScreen == null) {
      GetStorage().write(ISCURRENTCHATCONVERSATIONSCREEN, false);
    } else {
      GetStorage().write(ISCURRENTCHATCONVERSATIONSCREEN, isChatConversationScreen);
    }
  }

  static bool get isCurrentChatConversationScreen => GetStorage().read(ISCURRENTCHATCONVERSATIONSCREEN) ?? false;

  static set conversationId(String? conversationId) {
    if (conversationId == null) {
      GetStorage().write(CONVERSATION_ID, '');
    } else {
      GetStorage().write(CONVERSATION_ID, conversationId);
    }
  }

  static String get conversationId => GetStorage().read(CONVERSATION_ID) ?? '';

  static void setStringValue(String key, String value) {
    GetStorage().write(key, value);
  }

  static String getStringValue(String key) {
    return GetStorage().read(key) ?? '';
  }

  static removedAllKey(){
    GetStorage().remove(CURRENT_USER_ID);
    GetStorage().remove(SIGNUP_STATUS);
    GetStorage().remove(USER_DATA);
    GetStorage().remove(USER_NEW_DATA);
    GetStorage().remove(ID_TOKEN);
    GetStorage().remove(START_DATA);
    GetStorage().remove(SWIPE_PER_DAY);
    GetStorage().remove(TODAY_SWIPE);
    GetStorage().remove(SUPERLIKE);
    GetStorage().remove(REWINDDATA);
    GetStorage().remove(BOOSTUSER);
    GetStorage().remove(CURRENTPLAN);
    GetStorage().remove(SWIPEPERMONTH);
    GetStorage().remove(MONTHSWIPE);
    GetStorage().remove(SUPERLIKECOUNT);
    GetStorage().remove(PREVIOUS_CARD_ID);
    GetStorage().remove(PREVIOUS_CONVERSATION_ID);
    GetStorage().remove(ISFIRSTTIMEOPEN);
    GetStorage().remove(TODAYCHATDATE);
    GetStorage().remove(ISCURRENTCHATCONVERSATIONSCREEN);
    GetStorage().remove(OLD_PURCHASE);
    GetStorage().remove(CONVERSATION_ID);
  }
}
