class AppConfig {
  final String flavor;
  final String goldPlanAppStoreId;
  final String platinumPlanAppStoreId;
  final String goldPlanPlayStoreId;
  final String platinumPlanPlayStoreId;
  final String privacyPolicyUrl;
  final String termsOfServiceUrl;
  final String contactUsUrl;
  final String apiUrl;

  AppConfig(
      {required this.flavor,
      required this.goldPlanAppStoreId,
      required this.platinumPlanAppStoreId,
      required this.goldPlanPlayStoreId,
      required this.platinumPlanPlayStoreId,
      required this.privacyPolicyUrl,
      required this.termsOfServiceUrl,
      required this.contactUsUrl,
      required this.apiUrl});
}
