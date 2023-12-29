import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hepy/app.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app_config.dart';

void main() async {

  await GetStorage.init();

  AppConfig devAppConfig = AppConfig(
      flavor: 'dev',
      goldPlanAppStoreId: 'com.mandaliyas.hepyapp.dev.gold.1mo',
      platinumPlanAppStoreId: 'com.mandaliyas.hepyapp.dev.platinum.1mo',
      goldPlanPlayStoreId: 'com.mandaliyas.hepyapp.dev.gold.1mo',
      platinumPlanPlayStoreId: 'com.mandaliyas.hepyapp.dev.platinum.1mo',
      privacyPolicyUrl: 'https://beta.hepy.app/privacy-policy.html',
      termsOfServiceUrl: 'https://beta.hepy.app/terms-of-service.html',
      contactUsUrl: 'https://beta.hepy.app/contact-us.html',
      apiUrl: 'https://asia-south1-hepy-app.cloudfunctions.net/api/app/');
  Widget app = await initializeApp(devAppConfig);

  /// if App is open very first time and current user
  /// is not null then we sign out firebase session,
  /// that after continue our flow.
  if (PreferenceUtils.isOpenFirstTime &&
      CommonUtils().auth.currentUser == null) {
    // await CommonUtils().auth.signOut();
    PreferenceUtils.isOpenFirstTime = false;
  }
  runApp(app);
}
