import 'package:hepy/app/Utils/preference_utils.dart';

class ApiUrl {
  static String baseUrl = PreferenceUtils.getAppConfig.apiUrl;
  // static const String pushSend = 'https://fcm.googleapis.com/fcm/send';

  static String uploadPhotoPath = '${baseUrl}profile-photo';
  static String replacePhoto = '${baseUrl}profile-photo';
  static String deletePhoto = '${baseUrl}profile-photo';
  static String verifySelfie = '${baseUrl}verify-selfie';
  static String createSubscription = '${baseUrl}create-subscription';
  static String start = '${baseUrl}start';
  static String qod = '${baseUrl}question-of-the-day';
  static String card = '${baseUrl}user-cards';
  static String likedYouUser = '${baseUrl}liked-you-users';
  static String matchUserAndConversation = '${baseUrl}conversations';
  static String deleteAccount = '${baseUrl}delete-account';
  static String superLikeNotification = '${baseUrl}notifications/super-like';
  static String matchNotification = '${baseUrl}notifications/match';
  static String chatNotification = '${baseUrl}notifications/chat';
  static String unMatch = '${baseUrl}unmatch';
  static String updateSubscription = '${baseUrl}update-subscription';

}
