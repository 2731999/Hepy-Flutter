import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hepy/app/modules/aboutme/binding/about_me_binding.dart';
import 'package:hepy/app/modules/aboutme/view/about_me_view.dart';
import 'package:hepy/app/modules/add_language/binding/add_language_binding.dart';
import 'package:hepy/app/modules/add_language/view/add_language_view.dart';
import 'package:hepy/app/modules/add_more_photos/binding/add_more_photo_binding.dart';
import 'package:hepy/app/modules/add_more_photos/view/add_more_photos_view.dart';
import 'package:hepy/app/modules/banned/binding/banned_view_binding.dart';
import 'package:hepy/app/modules/banned/view/bannedview.dart';
import 'package:hepy/app/modules/chat/controller/chat_controller.dart';
import 'package:hepy/app/modules/chat/view/chat_view.dart';
import 'package:hepy/app/modules/chatmessage/binding/chat_message_binding.dart';
import 'package:hepy/app/modules/chatmessage/view/chat_message_view.dart';
import 'package:hepy/app/modules/chatmessagepreview/binding/chat_message_preview_binding.dart';
import 'package:hepy/app/modules/chatmessagepreview/view/chat_message_preview_view.dart';
import 'package:hepy/app/modules/dashboard/binding/dashboard_binding.dart';
import 'package:hepy/app/modules/dashboard/view/dashboard_view.dart';
import 'package:hepy/app/modules/dob/binding/dob_binding.dart';
import 'package:hepy/app/modules/dob/view/dob_view.dart';
import 'package:hepy/app/modules/edit_profile/binding/edit_profile_binding.dart';
import 'package:hepy/app/modules/edit_profile/view/edit_profile_view.dart';
import 'package:hepy/app/modules/email/binding/email_binding.dart';
import 'package:hepy/app/modules/email/view/email_view.dart';
import 'package:hepy/app/modules/gender/binding/gender_binding.dart';
import 'package:hepy/app/modules/gender/view/gender_view.dart';
import 'package:hepy/app/modules/home/userdetails/binding/home_card_details_binding.dart';
import 'package:hepy/app/modules/home/userdetails/view/home_card_details_view.dart';
import 'package:hepy/app/modules/location/binding/location_binding.dart';
import 'package:hepy/app/modules/location/view/location_view.dart';
import 'package:hepy/app/modules/lookingfor/binding/looking_for_binding.dart';
import 'package:hepy/app/modules/lookingfor/view/looking_for_view.dart';
import 'package:hepy/app/modules/name/binding/name_binding.dart';
import 'package:hepy/app/modules/name/view/name_view.dart';
import 'package:hepy/app/modules/qod/binding/qod_binding.dart';
import 'package:hepy/app/modules/qod/view/qod_view.dart';
import 'package:hepy/app/modules/selfiecamera/binding/selfiecamera_binding.dart';
import 'package:hepy/app/modules/selfiecamera/view/selfie_camera_view.dart';
import 'package:hepy/app/modules/setting/binding/setting_binding.dart';
import 'package:hepy/app/modules/setting/view/setting_view.dart';
import 'package:hepy/app/modules/signin/binding/signin_binding.dart';
import 'package:hepy/app/modules/signin/view/signin_view.dart';
import 'package:hepy/app/modules/signup_photos/view/signup_photos_view.dart';
import 'package:hepy/app/modules/verifyyourself/binding/verify_your_self_binding.dart';
import 'package:hepy/app/modules/verifyyourself/view/verify_your_self_view.dart';
import 'package:hepy/app/modules/webview/binding/webview_binding.dart';
import 'package:hepy/app/modules/webview/view/webview.dart';
import 'package:hepy/app/modules/welcome/binding/welcome_binding.dart';
import 'package:hepy/app/modules/welcome/view/welcome_view.dart';
import 'package:hepy/app/routes/app_routes.dart';

import '../modules/signup_photos/binding/signup_photos_binding.dart';

class AppPages {
  AppPages._();

  static String INITIAL = Routes.WELCOME;

  static final routes = [
    // Welcome view
    GetPage(
      name: Paths.WELCOME,
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
    ),

    //Location View
    GetPage(
      name: Paths.LOCATION,
      page: () => LocationView(),
      binding: LocationBinding(),
    ),

    //Name view
    GetPage(
      name: Paths.NAME,
      page: () => NameView(),
      binding: NameBinding(),
      transition: Transition.rightToLeft,
    ),

    //Dob View
    GetPage(
      name: Paths.DOB,
      page: () => DobView(),
      binding: DobBinding(),
      transition: Transition.rightToLeft,
    ),

    //Gender View
    GetPage(
      name: Paths.GENDER,
      page: () => GenderView(),
      binding: GenderBinding(),
      transition: Transition.rightToLeft,
    ),

    //Looking for View
    GetPage(
      name: Paths.LOOKING_FOR,
      page: () => LookingForView(),
      binding: LookingForBinding(),
      transition: Transition.rightToLeft,
    ),

    //AboutMe View
    GetPage(
      name: Paths.ABOUT_ME,
      page: () => AboutMeView(),
      binding: AboutMeBinding(),
      transition: Transition.rightToLeft,
    ),

    //Language View
    GetPage(
      name: Paths.LANGUAGE,
      page: () => AddLanguageView(),
      binding: AddLanguageBinding(),
      transition: Transition.rightToLeft,
    ),

    //SignupPhotos View
    GetPage(
      name: Paths.SIGNUPPHOTOS,
      page: () => SignupPhotosView(),
      binding: SignupPhotosBinding(),
      transition: Transition.rightToLeft,
    ),

    //VerifyYourSelf View
    GetPage(
      name: Paths.VERIFYYOURSELF,
      page: () => VerifyYourSelfView(),
      binding: VerifyYourSelfBinding(),
      transition: Transition.rightToLeft,
    ),

    //Add more photos View
    GetPage(
      name: Paths.ADDMOREPHOTOS,
      page: () => AddMorePhotosView(),
      binding: AddMorePhotosBinding(),
      transition: Transition.rightToLeft,
    ),

    //Email View
    GetPage(
      name: Paths.EMAIL,
      page: () => EmailView(),
      binding: EmailBinding(),
      transition: Transition.rightToLeft,
    ),

    // SIGNIN view
    GetPage(
      name: Paths.SIGNIN,
      page: () => SignInView(),
      binding: SignInBinding(),
      transition: Transition.rightToLeft,
    ),

    // Home view
    GetPage(
      name: Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
      transition: Transition.rightToLeft,
    ),

    // QOD view
    GetPage(
      name: Paths.QOD,
      page: () => QODView(),
      binding: QODBinding(),
      transition: Transition.rightToLeft,
    ),

    // Chat message screen view
    GetPage(
      name: Paths.CHAT_MESSAGE_SCREEN,
      page: () => ChatMessageView(),
      binding: ChatMessageBinding(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: Paths.EDIT_PROFILE,
      page: () => EditProfileView(),
      binding: EditProfileBinding(),
    ),

    GetPage(
      name: Paths.SETTINGS_SCREEN,
      page: () => SettingView(),
      binding: SettingBinding(),
    ),

    GetPage(
      name: Paths.COMMON_WEBVIEW,
      page: () => CommonWebView(),
      binding: CommonWebViewBinding(),
    ),

    // Selfie camera screen view
    GetPage(
      name: Paths.SELFIE_CAMERA,
      page: () => SelfieCameraView(),
      binding: SelfieCameraBinding(),
    ),

    // Chat screen view
    GetPage(
      name: Paths.CHAT_SCREEN,
      page: () => ChatMessageView(),
      binding: ChatMessageBinding(),
    ),

    // ChatMessage preview screen view
    GetPage(
      name: Paths.CHAT_MESSAGE_PREVIEW,
      page: () => ChatMessagePreviewView(),
      binding: ChatMessagePreviewBinding(),
    ),

    // BACK_LOOKING_FOR view
    GetPage(
      name: Paths.BACK_LOOKING_FOR,
      page: () => LookingForView(),
      binding: LookingForBinding(),
      transition: Transition.leftToRight,
    ),

    // BACK_GENDER view
    GetPage(
      name: Paths.BACK_GENDER,
      page: () => GenderView(),
      binding: GenderBinding(),
      transition: Transition.leftToRight,
    ),

    // BACK_LANGUAGE view
    GetPage(
      name: Paths.BACK_LANGUAGE,
      page: () => AddLanguageView(),
      binding: AddLanguageBinding(),
      transition: Transition.leftToRight,
    ),

    // BACK_SIGNUPPHOTOS view
    GetPage(
      name: Paths.BACK_SIGNUPPHOTOS,
      page: () => SignupPhotosView(),
      binding: SignupPhotosBinding(),
      transition: Transition.leftToRight,
    ),

    // BACK_ABOUT_ME view
    GetPage(
      name: Paths.BACK_ABOUT_ME,
      page: () => AboutMeView(),
      binding: AboutMeBinding(),
      transition: Transition.leftToRight,
    ),

    // VERIFY your self view
    GetPage(
      name: Paths.BACK_VERIFYYOURSELF,
      page: () => VerifyYourSelfView(),
      binding: VerifyYourSelfBinding(),
      transition: Transition.leftToRight,
    ),

    // add more photos view
    GetPage(
      name: Paths.BACK_ADDMOREPHOTOS,
      page: () => AddMorePhotosView(),
      binding: AddMorePhotosBinding(),
      transition: Transition.leftToRight,
    ),

    //Home card details view
    GetPage(
      name: Paths.USERCRADSDETAILS,
      page: () => HomeCardDetailsView(),
      binding: HomeCardDetailsBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(seconds: 1),
    ),

    //Home card details view
    GetPage(
        name: Paths.BACK_CHAT,
        page: () => DashboardView(),
        binding: DashboardBinding(),
        transition: Transition.leftToRight,
    ),

    GetPage(
        name: Paths.BANNED_SCREEN,
        page: () => BannedView(),
        binding: BannedViewBinding(),
        transition: Transition.rightToLeft)
  ];
}
