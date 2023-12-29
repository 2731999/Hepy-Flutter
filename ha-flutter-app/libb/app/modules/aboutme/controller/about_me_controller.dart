import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/enum/about_me.dart';
import 'package:hepy/app/model/about_me_model.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/modules/add_more_photos/controller/add_more_photos_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';
import 'package:hepy/app/widgets/widget_helper.dart';

class AboutMeController extends GetxController {
  RxString height = ''.obs;
  RxString exercise = ''.obs;
  RxString zodiac = ''.obs;
  RxString educationLevel = ''.obs;
  RxString drinking = ''.obs;
  RxString smoking = ''.obs;
  RxString kids = ''.obs;
  RxString religion = ''.obs;
  RxString politics = ''.obs;

  RxBool isAerobicSelected = false.obs;
  RxBool isStretchingSelected = false.obs;
  RxBool isStretchingCardo = false.obs;
  RxBool isDanceSelected = false.obs;
  RxBool isRunningSelected = false.obs;
  RxBool isWalkingSelected = false.obs;
  RxBool isExerciseSelected = false.obs;

  RxBool isZodiacAriesSelected = false.obs;
  RxBool isZodiacTaurusSelected = false.obs;
  RxBool isZodiacGeminiSelected = false.obs;
  RxBool isZodiacCancerSelected = false.obs;
  RxBool isZodiacLeoSelected = false.obs;
  RxBool isZodiacVirgoSelected = false.obs;
  RxBool isZodiacLibraSelected = false.obs;
  RxBool isZodiacScorpioSelected = false.obs;
  RxBool isZodiacSagittariusSelected = false.obs;
  RxBool isZodiacCapricornSelected = false.obs;
  RxBool isZodiacAquariusSelected = false.obs;
  RxBool isZodiacPiscesSelected = false.obs;
  RxBool isZodiacSelected = false.obs;

  RxBool isEduHighSchoolSelected = false.obs;
  RxBool isEduVocationalSchoolSelected = false.obs;
  RxBool isEduInCollageSelected = false.obs;
  RxBool isEduUnderGraduateSelected = false.obs;
  RxBool isEduInGradeSelected = false.obs;
  RxBool isEduGraduateSelected = false.obs;
  RxBool isEduSelected = false.obs;

  RxBool isDrinkSocially = false.obs;
  RxBool isDrinkNever = false.obs;
  RxBool isDrinkFrequently = false.obs;
  RxBool isDrinkSober = false.obs;
  RxBool isDrinkSelected = false.obs;

  RxBool isSmokeSocially = false.obs;
  RxBool isSmokeNever = false.obs;
  RxBool isSmokeRegularly = false.obs;
  RxBool isSmokeSelected = false.obs;

  RxBool isKidsWant = false.obs;
  RxBool isKidsDoNotWant = false.obs;
  RxBool isKidsMore = false.obs;
  RxBool isKidsHave = false.obs;
  RxBool isKidsNotSure = false.obs;
  RxBool isKidsSelected = false.obs;

  RxBool isReliAgnostic = false.obs;
  RxBool isReliAtheist = false.obs;
  RxBool isReliBuddhist = false.obs;
  RxBool isReliCatholic = false.obs;
  RxBool isReliChristian = false.obs;
  RxBool isReliHindu = false.obs;
  RxBool isReliJain = false.obs;
  RxBool isReliJewish = false.obs;
  RxBool isReliMormon = false.obs;
  RxBool isReliMuslim = false.obs;
  RxBool isReliZoroastrian = false.obs;
  RxBool isReliSikh = false.obs;
  RxBool isReliSpiritual = false.obs;
  RxBool isReliOther = false.obs;
  RxBool isReligionSelected = false.obs;

  RxBool isPoliticApolitical = false.obs;
  RxBool isPoliticModerate = false.obs;
  RxBool isPoliticLeft = false.obs;
  RxBool isPoliticRight = false.obs;
  RxBool isPoliticCommunist = false.obs;
  RxBool isPoliticSocialist = false.obs;
  RxBool isPoliticsSelected = false.obs;

  Rx<TextEditingController> heightController = TextEditingController().obs;
  RxList lstExercise = [].obs;
  RxBool isShowLoader = false.obs;
  RxList<String> aboutMeList = <String>[].obs;
  Rx<AboutMeModel> aboutMeModel = AboutMeModel().obs;
  AddMorePhotosController addMorePhotosController = AddMorePhotosController();
  RxString selectedValue = ''.obs;
  RxBool heightFocus = false.obs;

  @override
  void onInit() {}

  /// This method is validate height value
  /// Height value can not be null
  /// Height is not smaller then 120 or not max then 240
  bool heightValidation() {
    if (heightController.value.text.isEmpty) {
      WidgetHelper().showMessage(msg: StringsNameUtils.emptyHeightMessage);
      return false;
    }
    if (double.parse(heightController.value.text) < 105) {
      WidgetHelper().showMessage(msg: StringsNameUtils.smallHeightMessage);
      return false;
    }

    if (double.parse(heightController.value.text) > 240) {
      WidgetHelper().showMessage(msg: StringsNameUtils.maxHeightMessage);
      return false;
    }

    return true;
  }

  /// if height is validate successfully, then set it into text view
  /// and dismiss dialog.
  /// if not then display appropriate error
  setHeightValue() {
    if (heightValidation()) {
      height.value = heightController.value.text;
      insertAboutMeToDB(
        demographicKey: 'height',
        demographicValue: heightController.value.text,
      );
      back(isPreviousScreen: false);
    }
  }

  /// it is clear height value
  /// and dismiss dialog.
  clearHeightValue() {
    heightController.value.text = '';
    height.value = '';
    insertAboutMeToDB(
      demographicKey: 'height',
      demographicValue: height.value,
    );
    back(isPreviousScreen: false);
  }

  exerciseSelection(
      {bool aerobicSelection = false,
      bool stretchingSelection = false,
      bool cardioSelection = false,
      bool danceSelection = false,
      bool runningSelection = false,
      bool walkingSelection = false,
      bool isExerciseSelect = false,
      bool isInsert = false,
      String exerciseValue = ''}) {
    isAerobicSelected.value = aerobicSelection;
    isStretchingSelected.value = stretchingSelection;
    isStretchingCardo.value = cardioSelection;
    isDanceSelected.value = danceSelection;
    isRunningSelected.value = runningSelection;
    isWalkingSelected.value = walkingSelection;
    isExerciseSelected.value = isExerciseSelect;
    exercise.value = exerciseValue;
    if (isInsert) {
      insertAboutMeToDB(
        demographicKey: 'exercise',
        demographicValue: exercise.value,
      );
      back(isPreviousScreen: false);
    }
  }

  /// This method will select zodiac any one from all and set it's name
  zodiacSelection({
    bool arisSelection = false,
    bool taurusSelection = false,
    bool geminiSelection = false,
    bool cancerSelection = false,
    bool leoSelection = false,
    bool virgoSelection = false,
    bool libraSelection = false,
    bool scorpioSelection = false,
    bool sagittariusSelection = false,
    bool capricornSelection = false,
    bool aquariusSelection = false,
    bool piscesSelection = false,
    bool zodiacSelect = false,
    bool isInsert = false,
    String zodiacValue = '',
  }) {
    isZodiacAriesSelected.value = arisSelection;
    isZodiacTaurusSelected.value = taurusSelection;
    isZodiacGeminiSelected.value = geminiSelection;
    isZodiacCancerSelected.value = cancerSelection;
    isZodiacLeoSelected.value = leoSelection;
    isZodiacVirgoSelected.value = virgoSelection;
    isZodiacLibraSelected.value = libraSelection;
    isZodiacScorpioSelected.value = scorpioSelection;
    isZodiacSagittariusSelected.value = sagittariusSelection;
    isZodiacCapricornSelected.value = capricornSelection;
    isZodiacAquariusSelected.value = aquariusSelection;
    isZodiacPiscesSelected.value = piscesSelection;
    isZodiacSelected.value = zodiacSelect;
    zodiac.value = zodiacValue;
    if (isInsert) {
      insertAboutMeToDB(
        demographicKey: 'zodiac',
        demographicValue: zodiac.value,
      );
      back(isPreviousScreen: false);
    }
  }

  educationLevelSelection({
    bool isHighSchoolSelected = false,
    bool isVocationalSchoolSelected = false,
    bool isInCollageSelected = false,
    bool isUnderGraduateSelected = false,
    bool isInGradeSelected = false,
    bool isGraduateSelected = false,
    bool isEduSelect = false,
    bool isInsert = false,
    String education = '',
  }) {
    isEduHighSchoolSelected.value = isHighSchoolSelected;
    isEduVocationalSchoolSelected.value = isVocationalSchoolSelected;
    isEduInCollageSelected.value = isInCollageSelected;
    isEduUnderGraduateSelected.value = isUnderGraduateSelected;
    isEduInGradeSelected.value = isInGradeSelected;
    isEduGraduateSelected.value = isGraduateSelected;
    isEduSelected.value = isEduSelect;
    educationLevel.value = education;
    if (isInsert) {
      insertAboutMeToDB(
        demographicKey: 'educationLevel',
        demographicValue: educationLevel.value,
      );
      back(isPreviousScreen: false);
    }
  }

  drinkingSelection(
      {bool isSociallySelected = false,
      bool isNeverSelected = false,
      bool isFrequentlySelected = false,
      bool isSoberSelected = false,
      bool isDrinkSelect = false,
      bool isInsert = false,
      String drink = ''}) {
    isDrinkSocially.value = isSociallySelected;
    isDrinkNever.value = isNeverSelected;
    isDrinkFrequently.value = isFrequentlySelected;
    isDrinkSober.value = isSoberSelected;
    isDrinkSelected.value = isDrinkSelect;
    drinking.value = drink;
    if (isInsert) {
      insertAboutMeToDB(
        demographicKey: 'drinking',
        demographicValue: drinking.value,
      );
      back(isPreviousScreen: false);
    }
  }

  smokingSelection({
    bool isSociallySelected = false,
    bool isNeverSelected = false,
    bool isRegularlySelected = false,
    bool isSmokeSelect = false,
    bool isInsert = false,
    String smoke = '',
  }) {
    isSmokeSocially.value = isSociallySelected;
    isSmokeNever.value = isNeverSelected;
    isSmokeRegularly.value = isRegularlySelected;
    isSmokeSelected.value = isSmokeSelect;
    smoking.value = smoke;
    if (isInsert) {
      insertAboutMeToDB(
        demographicKey: 'smoking',
        demographicValue: smoking.value,
      );
      back(isPreviousScreen: false);
    }
  }

  kidsSelection({
    bool isWant = false,
    bool isDoNot = false,
    bool isMore = false,
    bool isHave = false,
    bool isNotSure = false,
    bool isKidsSelect = false,
    bool isInsert = false,
    String kids = '',
  }) {
    isKidsWant.value = isWant;
    isKidsDoNotWant.value = isDoNot;
    isKidsMore.value = isMore;
    isKidsHave.value = isHave;
    isKidsNotSure.value = isNotSure;
    isKidsSelected.value = isKidsSelect;
    this.kids.value = kids;
    if (isInsert) {
      insertAboutMeToDB(
        demographicKey: 'kids',
        demographicValue: this.kids.value,
      );
      back(isPreviousScreen: false);
    }
  }

  religionSelection(
      {bool isAgnostic = false,
      bool isAtheist = false,
      bool isBuddhist = false,
      bool isCatholic = false,
      bool isChristian = false,
      bool isHindu = false,
      bool isJain = false,
      bool isJewish = false,
      bool isMormon = false,
      bool isMuslim = false,
      bool isZoroastrian = false,
      bool isSikh = false,
      bool isSpiritual = false,
      bool isOther = false,
      bool isReligionSelect = false,
      bool isInsert = false,
      String religion = ''}) {
    isReliAgnostic.value = isAgnostic;
    isReliAtheist.value = isAtheist;
    isReliBuddhist.value = isBuddhist;
    isReliCatholic.value = isCatholic;
    isReliChristian.value = isChristian;
    isReliHindu.value = isHindu;
    isReliJain.value = isJain;
    isReliJewish.value = isJewish;
    isReliMormon.value = isMormon;
    isReliMuslim.value = isMuslim;
    isReliZoroastrian.value = isZoroastrian;
    isReliSikh.value = isSikh;
    isReliSpiritual.value = isSpiritual;
    isReliOther.value = isOther;
    isReligionSelected.value = isReligionSelect;
    this.religion.value = religion;
    if (isInsert) {
      insertAboutMeToDB(
        demographicKey: 'religion',
        demographicValue: this.religion.value,
      );
      back(isPreviousScreen: false);
    }
  }

  politicsSelection(
      {bool isApolitical = false,
      bool isModerate = false,
      bool isLeft = false,
      bool isRight = false,
      bool isCommunist = false,
      bool isSocialist = false,
      bool isPoliticSelect = false,
      bool isInsert = false,
      String politics = ''}) {
    isPoliticApolitical.value = isApolitical;
    isPoliticModerate.value = isModerate;
    isPoliticLeft.value = isLeft;
    isPoliticRight.value = isRight;
    isPoliticCommunist.value = isCommunist;
    isPoliticSocialist.value = isSocialist;
    isPoliticsSelected.value = isPoliticSelect;
    this.politics.value = politics;
    if (isInsert) {
      insertAboutMeToDB(
        demographicKey: 'politics',
        demographicValue: this.politics.value,
      );
      back(isPreviousScreen: false);
    }
  }

  /// this method is insert Demographic data into db.
  insertAboutMeToDB(
      {required String demographicKey, required demographicValue}) {
    UserTbl().addAboutMe(
        aboutMeKey: demographicKey,
        aboutMeValue: demographicValue,
        currentUser: CommonUtils().auth.currentUser!);
  }

  updateSignupStatus() {
    UserTbl().updateAboutMeSignupStatus(
        currentUser: CommonUtils().auth.currentUser!);
    navigateToLanguageScreen();
  }

  navigateToLanguageScreen() {
    Get.offNamed(Routes.LANGUAGE);
  }

  back({required bool isPreviousScreen}) {
    CommonUtils()
        .backFromScreenOrExit(isPreviousScreen, Routes.BACK_LOOKING_FOR);
  }

  aerobicExerciseSelection({required bool isInsertData}) {
    exerciseSelection(
        aerobicSelection: true,
        isExerciseSelect: true,
        isInsert: isInsertData,
        exerciseValue: Exercise.Aerobic.name);
  }

  stretchingExerciseSelection({required bool isInsertData}) {
    exerciseSelection(
        stretchingSelection: true,
        isExerciseSelect: true,
        isInsert: isInsertData,
        exerciseValue: Exercise.Stretching.name);
  }

  cardioExerciseSelection({required bool isInsertData}) {
    exerciseSelection(
        cardioSelection: true,
        isExerciseSelect: true,
        isInsert: isInsertData,
        exerciseValue: Exercise.Cardio.name);
  }

  danceExerciseSelection({required bool isInsertData}) {
    exerciseSelection(
        danceSelection: true,
        isExerciseSelect: true,
        isInsert: isInsertData,
        exerciseValue: Exercise.Dance.name);
  }

  runningExerciseSelection({required bool isInsertData}) {
    exerciseSelection(
        runningSelection: true,
        isExerciseSelect: true,
        isInsert: isInsertData,
        exerciseValue: Exercise.Running.name);
  }

  walkingExerciseSelection({required bool isInsertData}) {
    exerciseSelection(
        walkingSelection: true,
        isExerciseSelect: true,
        isInsert: isInsertData,
        exerciseValue: Exercise.Walking.name);
  }

  ariseZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
        arisSelection: true,
        zodiacSelect: true,
        isInsert: isInsertData,
        zodiacValue: Zodiac.Aries.name);
  }

  taurusZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
        taurusSelection: true,
        zodiacSelect: true,
        isInsert: isInsertData,
        zodiacValue: Zodiac.Taurus.name);
  }

  geminiZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      geminiSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Gemini.name,
    );
  }

  cancerZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      cancerSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Cancer.name,
    );
  }

  leoZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      leoSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Leo.name,
    );
  }

  virgoZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      virgoSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Virgo.name,
    );
  }

  libraZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      libraSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Libra.name,
    );
  }

  scorpioZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      scorpioSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Scorpio.name,
    );
  }

  sagittariusZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      sagittariusSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Sagittarius.name,
    );
  }

  capricornZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      capricornSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Capricorn.name,
    );
  }

  aquariusZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      aquariusSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Aquarius.name,
    );
  }

  piscesZodiacSelection({required bool isInsertData}) {
    zodiacSelection(
      piscesSelection: true,
      zodiacSelect: true,
      isInsert: isInsertData,
      zodiacValue: Zodiac.Pisces.name,
    );
  }

  highSchoolEducationSelection({required bool isInsertData}) {
    educationLevelSelection(
      isHighSchoolSelected: true,
      isEduSelect: true,
      isInsert: isInsertData,
      education: StringsNameUtils.eduHighSchool,
    );
  }

  vocationalSchoolEducationSelection({required bool isInsertData}) {
    educationLevelSelection(
      isVocationalSchoolSelected: true,
      isEduSelect: true,
      isInsert: isInsertData,
      education: StringsNameUtils.eduVocationalSchool,
    );
  }

  inCollageEducationSelection({required bool isInsertData}) {
    educationLevelSelection(
      isInCollageSelected: true,
      isEduSelect: true,
      isInsert: isInsertData,
      education: StringsNameUtils.eduInCollage,
    );
  }

  inGradeEducationSelection({required bool isInsertData}) {
    educationLevelSelection(
      isInGradeSelected: true,
      isEduSelect: true,
      isInsert: isInsertData,
      education: StringsNameUtils.eduInGradSchool,
    );
  }

  underGraduateEducationSelection({required bool isInsertData}) {
    educationLevelSelection(
      isUnderGraduateSelected: true,
      isEduSelect: true,
      isInsert: isInsertData,
      education: StringsNameUtils.eduUnderGraduate,
    );
  }

  graduateDegreeEducationSelection({required bool isInsertData}) {
    educationLevelSelection(
      isGraduateSelected: true,
      isEduSelect: true,
      isInsert: isInsertData,
      education: StringsNameUtils.eduGraduateDegree,
    );
  }

  sociallyDrinkingSelection({required bool isInsertData}) {
    drinkingSelection(
      isSociallySelected: true,
      isDrinkSelect: true,
      isInsert: isInsertData,
      drink: Drink.Socially.name,
    );
  }

  neverDrinkingSelection({required bool isInsertData}) {
    drinkingSelection(
      isNeverSelected: true,
      isDrinkSelect: true,
      isInsert: isInsertData,
      drink: Drink.Never.name,
    );
  }

  frequentlyDrinkingSelection({required bool isInsertData}) {
    drinkingSelection(
      isFrequentlySelected: true,
      isDrinkSelect: true,
      isInsert: isInsertData,
      drink: Drink.Frequently.name,
    );
  }

  soberDrinkingSelection({required bool isInsertData}) {
    drinkingSelection(
      isSoberSelected: true,
      isDrinkSelect: true,
      isInsert: isInsertData,
      drink: Drink.Sober.name,
    );
  }

  sociallySmokingSelection({required bool isInsertData}) {
    smokingSelection(
      isSociallySelected: true,
      isSmokeSelect: true,
      isInsert: isInsertData,
      smoke: Smoke.Socially.name,
    );
  }

  neverSmokingSelection({required bool isInsertData}) {
    smokingSelection(
      isNeverSelected: true,
      isSmokeSelect: true,
      isInsert: isInsertData,
      smoke: Smoke.Never.name,
    );
  }

  regularlySmokingSelection({required bool isInsertData}) {
    smokingSelection(
      isRegularlySelected: true,
      isSmokeSelect: true,
      isInsert: isInsertData,
      smoke: Smoke.Regularly.name,
    );
  }

  wantSomeDayKidsSelection({required bool isInsertData}) {
    kidsSelection(
      isWant: true,
      isKidsSelect: true,
      isInsert: isInsertData,
      kids: StringsNameUtils.kidsSomeDay,
    );
  }

  doNotWantKidsSelection({required bool isInsertData}) {
    kidsSelection(
      isDoNot: true,
      isKidsSelect: true,
      isInsert: isInsertData,
      kids: StringsNameUtils.kidsDoNotWant,
    );
  }

  wantMoreKidsSelection({required bool isInsertData}) {
    kidsSelection(
      isMore: true,
      isKidsSelect: true,
      isInsert: isInsertData,
      kids: StringsNameUtils.kidsMore,
    );
  }

  doNotWantMoreKidsSelection({required bool isInsertData}) {
    kidsSelection(
      isHave: true,
      isKidsSelect: true,
      isInsert: isInsertData,
      kids: StringsNameUtils.kidsHave,
    );
  }

  notSureKidsSelection({required bool isInsertData}) {
    kidsSelection(
      isNotSure: true,
      isKidsSelect: true,
      isInsert: isInsertData,
      kids: StringsNameUtils.kidsNoSure,
    );
  }

  agnosticReligionSelection({required bool isInsertData}) {
    religionSelection(
      isAgnostic: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Agnostic.name,
    );
  }

  atheistReligionSelection({required bool isInsertData}) {
    religionSelection(
      isAtheist: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Atheist.name,
    );
  }

  buddhistReligionSelection({required bool isInsertData}) {
    religionSelection(
      isBuddhist: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Buddhist.name,
    );
  }

  catholicReligionSelection({required bool isInsertData}) {
    religionSelection(
      isCatholic: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Catholic.name,
    );
  }

  christianReligionSelection({required bool isInsertData}) {
    religionSelection(
      isChristian: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Christian.name,
    );
  }

  hinduReligionSelection({required bool isInsertData}) {
    religionSelection(
      isHindu: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Hindu.name,
    );
  }

  jainReligionSelection({required bool isInsertData}) {
    religionSelection(
      isJain: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Jain.name,
    );
  }

  jewishReligionSelection({required bool isInsertData}) {
    religionSelection(
      isJewish: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Jewish.name,
    );
  }

  mormonReligionSelection({required bool isInsertData}) {
    religionSelection(
      isMormon: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Mormon.name,
    );
  }

  muslimReligionSelection({required bool isInsertData}) {
    religionSelection(
      isMuslim: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Muslim.name,
    );
  }

  zoroastrianReligionSelection({required bool isInsertData}) {
    religionSelection(
      isZoroastrian: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Zoroastrian.name,
    );
  }

  sikhReligionSelection({required bool isInsertData}) {
    religionSelection(
      isSikh: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Sikh.name,
    );
  }

  spiritualReligionSelection({required bool isInsertData}) {
    religionSelection(
      isSpiritual: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Spiritual.name,
    );
  }

  otherReligionSelection({required bool isInsertData}) {
    religionSelection(
      isOther: true,
      isReligionSelect: true,
      isInsert: isInsertData,
      religion: Religion.Other.name,
    );
  }

  apoliticalPoliticsSelection({required bool isInsertData}) {
    politicsSelection(
      isApolitical: true,
      isPoliticSelect: true,
      isInsert: isInsertData,
      politics: Politics.Apolitical.name,
    );
  }

  moderatePoliticsSelection({required bool isInsertData}) {
    politicsSelection(
      isModerate: true,
      isPoliticSelect: true,
      isInsert: isInsertData,
      politics: Politics.Moderate.name,
    );
  }

  leftPoliticsSelection({required bool isInsertData}) {
    politicsSelection(
      isLeft: true,
      isPoliticSelect: true,
      isInsert: isInsertData,
      politics: Politics.Left.name,
    );
  }

  communistPoliticsSelection({required bool isInsertData}) {
    politicsSelection(
      isCommunist: true,
      isPoliticSelect: true,
      isInsert: isInsertData,
      politics: Politics.Communist.name,
    );
  }

  socialistPoliticsSelection({required bool isInsertData}) {
    politicsSelection(
      isSocialist: true,
      isPoliticSelect: true,
      isInsert: isInsertData,
      politics: Politics.Socialist.name,
    );
  }

  rightPoliticsSelection({required bool isInsertData}) {
    politicsSelection(
      isRight: true,
      isPoliticSelect: true,
      isInsert: isInsertData,
      politics: Politics.Right.name,
    );
  }

  getHeightAndSetIt() async {
    UserNewModel? model = PreferenceUtils.getNewModelData;
    if (model != null && model.demographics != null) {
      Map<String, dynamic>? map = model.demographics?.toJson();

      /// Height data set
      if (map!.containsKey("height")) {
        var heightValue = map['height'].toString().split(' ');
        heightController.value.text = heightValue[0];
        height.value = map['height']??'';
      }

      /// exercise data set
      if (map.containsKey('exercise')) {
        String exerciseValue = map['exercise'];
        if (exerciseValue.isNotEmpty) {
          switch (exerciseValue) {
            case 'Aerobic':
              aerobicExerciseSelection(isInsertData: false);
              break;
            case 'Stretching':
              stretchingExerciseSelection(isInsertData: false);
              break;
            case 'Cardio':
              cardioExerciseSelection(isInsertData: false);
              break;
            case 'Dance':
              danceExerciseSelection(isInsertData: false);
              break;
            case 'Running':
              runningExerciseSelection(isInsertData: false);
              break;
            case 'Walking':
              walkingExerciseSelection(isInsertData: false);
              break;
          }
        }
      }

      /// zodiac data set
      if (map.containsKey('zodiac')) {
        String zodiacValue = map['zodiac'];
        if (zodiacValue.isNotEmpty) {
          switch (zodiacValue) {
            case 'Aries':
              ariseZodiacSelection(isInsertData: false);
              break;
            case 'Taurus':
              taurusZodiacSelection(isInsertData: false);
              break;
            case 'Gemini':
              geminiZodiacSelection(isInsertData: false);
              break;
            case 'Cancer':
              cancerZodiacSelection(isInsertData: false);
              break;
            case 'Leo':
              leoZodiacSelection(isInsertData: false);
              break;
            case 'Virgo':
              virgoZodiacSelection(isInsertData: false);
              break;
            case 'Libra':
              libraZodiacSelection(isInsertData: false);
              break;
            case 'Scorpio':
              scorpioZodiacSelection(isInsertData: false);
              break;
            case 'Sagittarius':
              sagittariusZodiacSelection(isInsertData: false);
              break;
            case 'Capricorn':
              capricornZodiacSelection(isInsertData: false);
              break;
            case 'Aquarius':
              aquariusZodiacSelection(isInsertData: false);
              break;
            case 'Pisces':
              piscesZodiacSelection(isInsertData: false);
              break;
          }
        }
      }

      /// educationLevel data set
      if (map.containsKey('educationLevel')) {
        String educationValue = map['educationLevel'];
        if (educationValue.isNotEmpty) {
          switch (educationValue) {
            case 'High school':
              highSchoolEducationSelection(isInsertData: false);
              break;
            case 'Vocational school':
              vocationalSchoolEducationSelection(isInsertData: false);
              break;
            case 'In college':
              inCollageEducationSelection(isInsertData: false);
              break;
            case 'Undergraduate degree':
              underGraduateEducationSelection(isInsertData: false);
              break;
            case 'In grad school':
              inGradeEducationSelection(isInsertData: false);
              break;
            case 'Graduate degree':
              graduateDegreeEducationSelection(isInsertData: false);
              break;
          }
        }
      }

      /// drinking data set
      if (map.containsKey('drinking')) {
        String drinkingValue = map['drinking'];
        if (drinkingValue.isNotEmpty) {
          switch (drinkingValue) {
            case 'Socially':
              sociallyDrinkingSelection(isInsertData: false);
              break;
            case 'Never':
              neverDrinkingSelection(isInsertData: false);
              break;
            case 'Frequently':
              frequentlyDrinkingSelection(isInsertData: false);
              break;
            case 'Sober':
              soberDrinkingSelection(isInsertData: false);
              break;
          }
        }
      }

      /// smoking data set
      if (map.containsKey('smoking')) {
        String smokingValue = map['smoking'];
        if (smokingValue.isNotEmpty) {
          switch (smokingValue) {
            case 'Socially':
              sociallySmokingSelection(isInsertData: false);
              break;
            case 'Never':
              neverSmokingSelection(isInsertData: false);
              break;
            case 'Regularly':
              regularlySmokingSelection(isInsertData: false);
              break;
          }
        }
      }

      /// kids data set
      if (map.containsKey('kids')) {
        String kidsValue = map['kids'];
        if (kidsValue.isNotEmpty) {
          switch (kidsValue) {
            case 'Want someday':
              wantSomeDayKidsSelection(isInsertData: false);
              break;
            case 'Don’t want':
              doNotWantKidsSelection(isInsertData: false);
              break;
            case 'Have & want more':
              wantMoreKidsSelection(isInsertData: false);
              break;
            case 'Have & don’t want more':
              doNotWantMoreKidsSelection(isInsertData: false);
              break;
            case 'Not sure yet':
              notSureKidsSelection(isInsertData: false);
              break;
          }
        }
      }

      /// religion data set
      if (map.containsKey('religion')) {
        String religionsValue = map['religion'];
        if (religionsValue.isNotEmpty) {
          switch (religionsValue) {
            case 'Agnostic':
              agnosticReligionSelection(isInsertData: false);
              break;
            case 'Atheist':
              atheistReligionSelection(isInsertData: false);
              break;
            case 'Buddhist':
              buddhistReligionSelection(isInsertData: false);
              break;
            case 'Catholic':
              catholicReligionSelection(isInsertData: false);
              break;
            case 'Christian':
              christianReligionSelection(isInsertData: false);
              break;
            case 'Hindu':
              hinduReligionSelection(isInsertData: false);
              break;
            case 'Jain':
              jainReligionSelection(isInsertData: false);
              break;
            case 'Jewish':
              jewishReligionSelection(isInsertData: false);
              break;
            case 'Mormon':
              mormonReligionSelection(isInsertData: false);
              break;
            case 'Muslim':
              muslimReligionSelection(isInsertData: false);
              break;
            case 'Zoroastrian':
              zoroastrianReligionSelection(isInsertData: false);
              break;
            case 'Sikh':
              sikhReligionSelection(isInsertData: false);
              break;
            case 'Spiritual':
              spiritualReligionSelection(isInsertData: false);
              break;
            case 'Other':
              otherReligionSelection(isInsertData: false);
              break;
          }
        }
      }

      /// politics data set
      if (map.containsKey('politics')) {
        String politicsValue = map['politics'];
        if (politicsValue.isNotEmpty) {
          switch (politicsValue) {
            case 'Apolitical':
              apoliticalPoliticsSelection(isInsertData: false);
              break;
            case 'Moderate':
              moderatePoliticsSelection(isInsertData: false);
              break;
            case 'Left':
              leftPoliticsSelection(isInsertData: false);
              break;
            case 'Right':
              rightPoliticsSelection(isInsertData: false);
              break;
            case 'Communist':
              communistPoliticsSelection(isInsertData: false);
              break;
            case 'Socialist':
              socialistPoliticsSelection(isInsertData: false);
              break;
          }
        }
      }
    }
    // await Future.delayed(const Duration(seconds: 1));
    isShowLoader.value = false;
  }

  getAboutMeData() async {
    addMorePhotosController.isLoading.value = true;
    UserNewModel? model = await PreferenceUtils.getNewModelData;
    debugPrint("getAboutMeData model  $model");
    debugPrint("getAboutMeData name  ${model?.demographics}");
    if (model != null && model.demographics != null) {
      aboutMeModel.value = AboutMeModel.fromMap(model.demographics);
      height.value = aboutMeModel.value.height!;
      exercise.value = aboutMeModel.value.exercise ?? '';
      educationLevel.value = aboutMeModel.value.educationLevel ?? '';
      zodiac.value = aboutMeModel.value.zodiac ?? '';
      drinking.value = aboutMeModel.value.drinking ?? '';
      kids.value = aboutMeModel.value.kids ?? '';
      smoking.value = aboutMeModel.value.smoking ?? '';
      politics.value = aboutMeModel.value.politics ?? '';
      religion.value = aboutMeModel.value.religion ?? '';
      isShowLoader.value = false;
      debugPrint("getAboutMeData aboutMeModel  ${aboutMeModel.value.exercise}");
    }
    // aboutMeList.value = getList(aboutKey.value);
    addMorePhotosController.isLoading.value = false;
  }

  bool isSelected(String key, String item, List<String> list) {
    debugPrint("setSelected isSelected key $key  list $list  item $item");
    if (key == StringsNameUtils.exercise) {
      if (list.contains(exercise.value) && exercise.value == item) {
        selectedValue.value = item;
        exercise.value = item;
        return true;
      }
    } else if (key == StringsNameUtils.zodiac) {
      if (list.contains(zodiac.value) && zodiac.value == item) {
        return true;
      }
    } else if (key == StringsNameUtils.drinking) {
      if (list.contains(drinking.value) && drinking.value == item) {
        return true;
      }
    } else if (key == StringsNameUtils.smoking) {
      if (list.contains(smoking.value) && smoking.value == item) {
        return true;
      }
    } else if (key == StringsNameUtils.kids) {
      if (list.contains(kids.value) && kids.value == item) {
        return true;
      }
    } else if (key == StringsNameUtils.educationLevel) {
      if (list.contains(educationLevel.value) && educationLevel.value == item) {
        return true;
      }
    } else if (key == StringsNameUtils.religion) {
      if (list.contains(religion.value) && religion.value == item) {
        return true;
      }
    } else if (key == StringsNameUtils.politics) {
      if (list.contains(politics.value) && politics.value == item) {
        return true;
      }
    }
    return false;
  }

  bool setSelected(String key, String value, List<String> list) {
    String dbKey = "exercise";
    selectedValue.value = value;
    if (key == StringsNameUtils.exercise) {
      dbKey = "exercise";
      if (list.contains(exercise.value) && exercise.value == value) {
        exercise.value = value;
        return true;
      }
    } else if (key == StringsNameUtils.zodiac) {
      dbKey = "zodiac";
      if (list.contains(zodiac.value) && zodiac.value == value) {
        zodiac.value = value;
        return true;
      }
    } else if (key == StringsNameUtils.drinking) {
      dbKey = "drinking";
      if (list.contains(drinking.value) && drinking.value == value) {
        drinking.value = value;
        return true;
      }
    } else if (key == StringsNameUtils.smoking) {
      dbKey = "kids";
      if (list.contains(smoking.value) && smoking.value == value) {
        smoking.value = value;
        return true;
      }
    } else if (key == StringsNameUtils.kids) {
      dbKey = "kids";
      if (list.contains(kids.value) && kids.value == value) {
        kids.value = value;
        return true;
      }
    } else if (key == StringsNameUtils.educationLevel) {
      dbKey = "educationLevel";
      if (list.contains(educationLevel.value) &&
          educationLevel.value == value) {
        educationLevel.value = value;
        return true;
      }
    } else if (key == StringsNameUtils.religion) {
      dbKey = "religion";
      if (list.contains(religion.value) && religion.value == value) {
        religion.value = value;
        return true;
      }
    } else if (key == StringsNameUtils.politics) {
      dbKey = "politics";
      if (list.contains(politics.value) && politics.value == value) {
        politics.value = value;
        return true;
      }
    }

    insertAboutMeToDB(
      demographicKey: dbKey,
      demographicValue: value,
    );
    debugPrint("setSelected key $key  dbKey $dbKey  value $value");
    back(isPreviousScreen: false);
    return false;
  }

  List<String> getList(String key) {
    debugPrint("setSelected getList ========key $key");
    List<String> zodiac = [
      'ARISE',
      'TAURUS',
      'GEMINI',
      'CANCER',
      'LEO',
      'VIRGO',
      'LIBRA',
      'SCORPIO',
      'SAGITTARIUS',
      'CAPRICORN',
      'AQUARIUS',
      'PISCES'
    ];

    List<String> exercise = [
      'AEROBIC',
      'STRETCHING',
      'CARDIO',
      'DANCE',
      'RUNNING',
      'WALKING'
    ];

    List<String> kidsList = [
      'WANT SOMEDAY',
      'DON\'T WANT',
      'HAVE & WANT MORE',
      'HAVE & DON\'T  WANT MORE',
      'NOT SURE YET'
    ];

    List<String> drinkingList = [
      'WANT SOMEDAY',
      'DON\'T WANT',
      'HAVE & WANT MORE',
      'HAVE & DON\'T  WANT MORE',
      'NOT SURE YET'
    ];

    List<String> religionList = [
      StringsNameUtils.religionAgnostic,
      StringsNameUtils.religionAtheist,
      StringsNameUtils.religionBuddhist,
      StringsNameUtils.religionCatholic,
      StringsNameUtils.religionChristian,
      StringsNameUtils.religionHindu,
      StringsNameUtils.religionJain,
      StringsNameUtils.religionJewish,
      StringsNameUtils.religionMormon,
      StringsNameUtils.religionMuslim,
      StringsNameUtils.religionSikh,
      StringsNameUtils.religionSpiritual,
      StringsNameUtils.religionOther
    ];

    if (key == StringsNameUtils.exercise) {
      aboutMeList.value = exercise;
      return exercise;
    } else if (key == StringsNameUtils.zodiac) {
      return zodiac;
    } else if (key == StringsNameUtils.drinking) {
      return drinkingList;
    } else if (key == StringsNameUtils.smoking) {
      return zodiac;
    } else if (key == StringsNameUtils.kids) {
      return kidsList;
    } else if (key == StringsNameUtils.educationLevel) {
      return zodiac;
    } else if (key == StringsNameUtils.religion) {
      return religionList;
    } else if (key == StringsNameUtils.politics) {
      return zodiac;
    }
    return exercise;
  }

  String getTitle(String key) {
    if (key == StringsNameUtils.exercise) {
      return StringsNameUtils.exercise;
    } else if (key == StringsNameUtils.zodiac) {
      return StringsNameUtils.zodiac;
    } else if (key == StringsNameUtils.drinking) {
      return StringsNameUtils.drinking;
    } else if (key == StringsNameUtils.smoking) {
      return StringsNameUtils.smoking;
    } else if (key == StringsNameUtils.kids) {
      return StringsNameUtils.kids;
    } else if (key == StringsNameUtils.educationLevel) {
      return StringsNameUtils.educationLevel;
    } else if (key == StringsNameUtils.religion) {
      return StringsNameUtils.religion;
    } else if (key == StringsNameUtils.politics) {
      return StringsNameUtils.politics;
    }

    return StringsNameUtils.exercise;
  }

  String getSubTitle(String key) {
    if (key == StringsNameUtils.exercise) {
      return StringsNameUtils.exercise;
    } else if (key == StringsNameUtils.zodiac) {
      return StringsNameUtils.zodiacContent;
    } else if (key == StringsNameUtils.drinking) {
      return StringsNameUtils.drinkContent;
    } else if (key == StringsNameUtils.smoking) {
      return StringsNameUtils.smokeContent;
    } else if (key == StringsNameUtils.kids) {
      return StringsNameUtils.kidsContent;
    } else if (key == StringsNameUtils.educationLevel) {
      return StringsNameUtils.eduContent;
    } else if (key == StringsNameUtils.religion) {
      return StringsNameUtils.religionContent;
    } else if (key == StringsNameUtils.politics) {
      return StringsNameUtils.politicsContent;
    }
    return StringsNameUtils.exerciseContent;
  }
}
