import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hepy/app.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app_config.dart';

void main() async {

  await GetStorage.init();

  AppConfig prodAppConfig = AppConfig(
      flavor: 'prod',
      goldPlanAppStoreId: 'com.hepy.app.gold.1mo',
      platinumPlanAppStoreId: 'com.hepy.app.platinum.1mo',
      goldPlanPlayStoreId: 'com.hepy.app.gold.1mo',
      platinumPlanPlayStoreId: 'com.hepy.app.platinum.1mo',
      privacyPolicyUrl: 'https://hepy.app/privacy-policy.html',
      termsOfServiceUrl: 'https://hepy.app/terms-of-service.html',
      contactUsUrl: 'https://hepy.app/contact-us.html',
      apiUrl: 'https://asia-south1-hepy-app-prod.cloudfunctions.net/api/app/');
  Widget app = await initializeApp(prodAppConfig);

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
