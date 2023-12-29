import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class AddLanguageController extends GetxController {
  RxList<String> lstLanguages = <String>[].obs;
  RxList<String> lstSelectedLanguage = <String>[].obs;
  late ScrollController controller;

  addLanguageToList() {
    lstLanguages.add(StringsNameUtils.english);
    lstLanguages.add(StringsNameUtils.afrikaans);
    lstLanguages.add(StringsNameUtils.albanian);
    lstLanguages.add(StringsNameUtils.arabic);
    lstLanguages.add(StringsNameUtils.armenian);
    lstLanguages.add(StringsNameUtils.basque);
    lstLanguages.add(StringsNameUtils.belarusian);
    lstLanguages.add(StringsNameUtils.bengali);
    lstLanguages.add(StringsNameUtils.breton);
    lstLanguages.add(StringsNameUtils.bulgarian);
    lstLanguages.add(StringsNameUtils.catalan);
    lstLanguages.add(StringsNameUtils.cebuano);
    lstLanguages.add(StringsNameUtils.chechen);
    lstLanguages.add(StringsNameUtils.chinese);
    lstLanguages.add(StringsNameUtils.chinese_cantonese);
    lstLanguages.add(StringsNameUtils.chinese_mandarin);
    lstLanguages.add(StringsNameUtils.croatian);
    lstLanguages.add(StringsNameUtils.czech);
    lstLanguages.add(StringsNameUtils.danish);
    lstLanguages.add(StringsNameUtils.dutch);
    lstLanguages.add(StringsNameUtils.esperanto);
    lstLanguages.add(StringsNameUtils.estonian);
    lstLanguages.add(StringsNameUtils.finnish);
    lstLanguages.add(StringsNameUtils.french);
    lstLanguages.add(StringsNameUtils.frisian);
    lstLanguages.add(StringsNameUtils.georgian);
    lstLanguages.add(StringsNameUtils.german);
    lstLanguages.add(StringsNameUtils.greek);
    lstLanguages.add(StringsNameUtils.gujarati);
    lstLanguages.add(StringsNameUtils.ancient_greek);
    lstLanguages.add(StringsNameUtils.hawaiian);
    lstLanguages.add(StringsNameUtils.hebrew);
    lstLanguages.add(StringsNameUtils.hindi);
    lstLanguages.add(StringsNameUtils.hungarian);
    lstLanguages.add(StringsNameUtils.icelandic);
    lstLanguages.add(StringsNameUtils.ilongo);
    lstLanguages.add(StringsNameUtils.indonesian);
    lstLanguages.add(StringsNameUtils.irish);
    lstLanguages.add(StringsNameUtils.italian);
    lstLanguages.add(StringsNameUtils.japanese);
    lstLanguages.add(StringsNameUtils.khmer);
    lstLanguages.add(StringsNameUtils.korean);
    lstLanguages.add(StringsNameUtils.latin);
    lstLanguages.add(StringsNameUtils.latvian);
    lstLanguages.add(StringsNameUtils.lISP);
    lstLanguages.add(StringsNameUtils.Lithuanian);
    lstLanguages.add(StringsNameUtils.malay);
    lstLanguages.add(StringsNameUtils.maori);
    lstLanguages.add(StringsNameUtils.mongolian);
    lstLanguages.add(StringsNameUtils.norwegian);
    lstLanguages.add(StringsNameUtils.occitan);
    lstLanguages.add(StringsNameUtils.persian);
    lstLanguages.add(StringsNameUtils.polish);
    lstLanguages.add(StringsNameUtils.portuguese);
    lstLanguages.add(StringsNameUtils.punjabi);
    lstLanguages.add(StringsNameUtils.romanian);
    lstLanguages.add(StringsNameUtils.rotuman);
    lstLanguages.add(StringsNameUtils.russian);
    lstLanguages.add(StringsNameUtils.sanskrit);
    lstLanguages.add(StringsNameUtils.sardinian);
    lstLanguages.add(StringsNameUtils.serbian);
    lstLanguages.add(StringsNameUtils.signlanguage);
    lstLanguages.add(StringsNameUtils.slovak);
    lstLanguages.add(StringsNameUtils.slovenian);
    lstLanguages.add(StringsNameUtils.spanish);
    lstLanguages.add(StringsNameUtils.swahili);
    lstLanguages.add(StringsNameUtils.swedish);
    lstLanguages.add(StringsNameUtils.tagalog);
    lstLanguages.add(StringsNameUtils.tamil);
    lstLanguages.add(StringsNameUtils.thai);
    lstLanguages.add(StringsNameUtils.tibetan);
    lstLanguages.add(StringsNameUtils.turkish);
    lstLanguages.add(StringsNameUtils.ukrainian);
    lstLanguages.add(StringsNameUtils.vietnamese);
    lstLanguages.add(StringsNameUtils.welsh);
    lstLanguages.add(StringsNameUtils.yiddish);
  }

  /// This method is add language in selected language list
  addLanguageAsSelectedLanguage({required String language}) {
    if (!lstSelectedLanguage.contains(language)) {
      Get.back();
      if (lstSelectedLanguage.length < 5) {
        lstSelectedLanguage.add(language);
        lstSelectedLanguage.refresh();
      } else {
        if (Get.isBottomSheetOpen!) {
          Get.back();
        }
        WidgetHelper().showMessage(msg: StringsNameUtils.maxLanguageMessage);
      }
    } else {
      if (Get.isBottomSheetOpen!) {
        Get.back();
      }
      WidgetHelper()
          .showMessage(msg: '$language ${StringsNameUtils.languageSelected}');
    }
  }

  editSelectedLanguageToDB({required bool isFromLanguage}) {
    if (lstSelectedLanguage.value.isNotEmpty) {
      UserTbl().addSelectedLanguage(
          lstSelectedLanguage: lstSelectedLanguage,
          currentUser: CommonUtils().auth.currentUser!,
          isFromLanguage: isFromLanguage);
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.minLanguageMessage);
    }
  }

  /// This method is remove language as selected language from list
  removeLanguageAsSelectedLanguage({required String language}) {
    if (lstSelectedLanguage.contains(language)) {
      lstSelectedLanguage.remove(language);
      lstSelectedLanguage.refresh();
    }
  }

  /// this method is insert Demographic data into db.
  insertSelectedLanguageToDB({required bool isFromLanguage}) {
    if (lstSelectedLanguage.value.isNotEmpty) {
      UserTbl().addSelectedLanguage(
          lstSelectedLanguage: lstSelectedLanguage,
          currentUser: CommonUtils().auth.currentUser!,
          isFromLanguage: isFromLanguage);
      navigateToSignupPhotoScreen();
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.minLanguageMessage);
    }
  }

  getLanguageAndSetIt() {
    UserNewModel? model = PreferenceUtils.getNewModelData;
    if (model != null && model.lstLanguage != null) {
      lstSelectedLanguage.value = model.lstLanguage!;
    }
  }

  navigateToSignupPhotoScreen() {
    Get.offNamed(Routes.SIGNUPPHOTOS);
  }

  navigateToBackScreen() {
    CommonUtils().backFromScreenOrExit(true, Routes.BACK_ABOUT_ME);
  }
}
