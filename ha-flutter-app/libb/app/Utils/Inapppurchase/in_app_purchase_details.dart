import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hepy/app/Database/UserTbl.dart';
import 'package:hepy/app/Utils/api/api_url.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/Utils/string_name_utils.dart';
import 'package:hepy/app/model/finish_in_app_purchase/upgrade_and_downgrade_plan.dart';
import 'package:hepy/app/model/oldpurchase/old_play_store_purchase.dart';
import 'package:hepy/app/model/oldpurchase/old_purchase_status.dart';
import 'package:hepy/app/model/oldpurchase/old_purchase_verification_data.dart';
import 'package:hepy/app/model/oldpurchase/old_purchase_wrapper.dart';
import 'package:hepy/app/model/user/user_new_model.dart';
import 'package:hepy/app/modules/like/view/like_view.dart';
import 'package:hepy/app/modules/setting/view/setting_view.dart';
import 'package:hepy/app/modules/welcome/controller/welcome_controller.dart';
import 'package:hepy/app/widgets/swipecards/card_provider.dart';
import 'package:hepy/app/widgets/widget_helper.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../api/api_provider.dart';

class InAppPurchaseDetails {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? subscription;
  bool isApiCall = false;

  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];

  List<String> kProductIds = Platform.isAndroid
      ? <String>[
          PreferenceUtils.getAppConfig.goldPlanPlayStoreId,
          PreferenceUtils.getAppConfig.platinumPlanPlayStoreId
        ]
      : <String>[
          PreferenceUtils.getAppConfig.goldPlanAppStoreId,
          PreferenceUtils.getAppConfig.platinumPlanAppStoreId
        ];

  Future<dynamic> initStoreInfo({required String productId}) async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    String priceWithCurrencySymbol = '';
    double price = 0.0;
    String currencySymbol = '';
    late ProductDetails productDetails;

    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    if (isAvailable) {
      final ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails(kProductIds.toSet());
      if (productDetailResponse.productDetails.isNotEmpty) {
        _products = productDetailResponse.productDetails;
      }

      if (_products.isNotEmpty) {
        for (ProductDetails details in _products) {
          if (productId == details.id) {
            priceWithCurrencySymbol = details.price;
            price = details.rawPrice;
            currencySymbol = details.currencySymbol;
            productDetails = details;
          }
        }
      }
    }
    return [priceWithCurrencySymbol, price, currencySymbol, productDetails];
  }

  purchaseView(
      {required ProductDetails productDetails,
      required int? oldPlanId,
      required int newPlanId}) async {
    late PurchaseParam purchaseParam;
    if (oldPlanId != newPlanId) {
      if (Platform.isAndroid &&
          PreferenceUtils.getNewModelData?.currentSubscriptionPlan
                  ?.playStorePurchaseData !=
              null) {
        // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
        // verify the latest status of you your subscription by using server side receipt validation
        // and update the UI accordingly. The subscription purchase status shown
        // inside the app may not be accurate.

        OldPlayStorePurchase? value = PreferenceUtils
            .getNewModelData?.currentSubscriptionPlan?.playStorePurchaseData;

        PurchaseVerificationData verificationData = PurchaseVerificationData(
            localVerificationData:
                value!.oldPlayStorePurchase!.localVerificationData!,
            serverVerificationData:
                value.oldPlayStorePurchase!.serverVerificationData!,
            source: value.oldPlayStorePurchase!.source!);

        PurchaseWrapper billingClientPurchase = PurchaseWrapper(
            orderId: value.oldPurchaseWrapper!.orderId!,
            packageName: value.oldPurchaseWrapper!.packageName!,
            purchaseTime: value.oldPurchaseWrapper!.purchaseTime!,
            purchaseToken: value.oldPurchaseWrapper!.purchaseToken!,
            signature: value.oldPurchaseWrapper!.signature!,
            skus: List<String>.from(value.oldPurchaseWrapper!.lstSku as List),
            isAutoRenewing: value.oldPurchaseWrapper!.isAutoRenewing!,
            originalJson: value.oldPurchaseWrapper!.originalJson!,
            isAcknowledged: value.oldPurchaseWrapper!.isAcknowledged!,
            purchaseState: PurchaseStateWrapper.purchased);

        GooglePlayPurchaseDetails oldPurchase = GooglePlayPurchaseDetails(
            purchaseID: value.purchaseID!,
            productID: value.productID!,
            verificationData: verificationData,
            transactionDate: value.transactionDate,
            billingClientPurchase: billingClientPurchase,
            status: PurchaseStatus.purchased);

        /*final GooglePlayPurchaseDetails oldSubscription =
        PreferenceUtils.getOldPurchaseDetails as GooglePlayPurchaseDetails;*/

        purchaseParam = GooglePlayPurchaseParam(
            productDetails: productDetails,
            applicationUserName: CommonUtils().auth.currentUser?.uid,
            changeSubscriptionParam: (oldPurchase != null)
                ? ChangeSubscriptionParam(
                    oldPurchaseDetails: oldPurchase,
                    prorationMode: newPlanId > oldPlanId!
                        ? ProrationMode.immediateWithTimeProration
                        : ProrationMode.deferred,
                  )
                : null);
      } else {
        if (Platform.isIOS) {
          CommonUtils.isStartLoading = true;
          CommonUtils().startLoading(Get.context!);
          WidgetHelper().showMessage(msg: StringsNameUtils.purchasing);
          String? uuid = await UserTbl()
              .getUuidToPurchaseIOSPlan(CommonUtils().auth.currentUser?.uid);
          purchaseParam = PurchaseParam(
              productDetails: productDetails, applicationUserName: uuid);
        } else {
          purchaseParam = PurchaseParam(
              productDetails: productDetails,
              applicationUserName: CommonUtils().auth.currentUser?.uid);
        }
      }

      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);

      final Stream<List<PurchaseDetails>> purchaseUpdated =
          _inAppPurchase.purchaseStream;
      subscription = purchaseUpdated.listen((purchaseDetailsList) {
        listenToPurchaseUpdate(
            purchaseDetailsList: purchaseDetailsList,
            oldPlanId: oldPlanId!,
            newPlanId: newPlanId);
      }, onDone: () {
        debugPrint("Subscription done}");
        subscription?.cancel();
      }, onError: (error) {
        debugPrint("Subscription error ====> ${error.toString()}");
      });
    } else {
      WidgetHelper().showMessage(msg: StringsNameUtils.alreadySubscribePlan);
    }
  }

  dynamic planPriceCalculation(
      {required double planPrice, required String currencySymbol}) {
    String finalPrice = '';
    String savedPrice = '';
    double price = (planPrice * 100) / 70;
    double savePrice = price - planPrice;
    finalPrice = '$currencySymbol${price.toStringAsFixed(2)}, ';
    savedPrice =
        '${StringsNameUtils.save}$currencySymbol${savePrice.toStringAsFixed(2)}';
    debugPrint('Plan final Price =====> $finalPrice');
    return [finalPrice, savedPrice];
  }

  void restorePurchase() {
    _inAppPurchase.restorePurchases();
  }

  void listenToPurchaseUpdate(
      {required List<PurchaseDetails> purchaseDetailsList,
      required int oldPlanId,
      required int newPlanId}) {
    purchaseDetailsList.forEach((purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        debugPrint("Purchase is Pending");
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          debugPrint("Purchase error");
          if (Platform.isIOS && CommonUtils.isStartLoading) {
            CommonUtils().stopLoading(Get.context!);
            CommonUtils.isStartLoading = false;
          }
          subscription?.cancel();
          subscription = null;
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {

          bool valid = await verifyPurchase(purchaseDetails);
          if (Platform.isIOS && CommonUtils.isStartLoading) {
            CommonUtils().stopLoading(Get.context!);
            CommonUtils.isStartLoading = false;
          }
          if (valid) {
            debugPrint("Purchase details ===> ${purchaseDetailsList}");
            _purchases = purchaseDetailsList;
            await _inAppPurchase.completePurchase(purchaseDetails);
            PreferenceUtils.setOldPurchaseDetails = purchaseDetails;
            MapEntry<String, PurchaseDetails>(
                purchaseDetails.productID, purchaseDetails);
            if (!isApiCall) {
              inAppPurchaseAPICall(
                  oldPlan: oldPlanId,
                  newPlan: newPlanId,
                  oldPurchaseDetails: Platform.isAndroid
                      ? purchaseDetails as GooglePlayPurchaseDetails
                      : null);
            }
          } else {
            debugPrint(
                "Purchase not valid details ===> ${purchaseDetailsList}");
            return;
          }
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          if (Platform.isIOS) {
            if (CommonUtils.isStartLoading) {
              CommonUtils().stopLoading(Get.context!);
              CommonUtils.isStartLoading = false;
            }
            var paymentWrapper = SKPaymentQueueWrapper();
            var transactions = await paymentWrapper.transactions();
            transactions.forEach((transaction) async {
              await paymentWrapper.finishTransaction(transaction);
              subscription?.cancel();
              subscription = null;
            });
          }
        } else {
          subscription?.cancel();
          subscription = null;
        }
      }
    });
  }

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  @override
  Future<void> disposeStore() async {
    if (Platform.isIOS) {
      var iosPlatformAddition = _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(null);
    }
  }

  inAppPurchaseAPICall(
      {required int oldPlan,
      required int newPlan,
      required GooglePlayPurchaseDetails? oldPurchaseDetails}) async {
    CommonUtils().startLoading(Get.context!);
    isApiCall = true;
    String? token = await CommonUtils().auth.currentUser?.getIdToken();
    ApiProvider apiProvider = ApiProvider();
    OldPlayStorePurchase oldPlayStorePurchase = OldPlayStorePurchase();
    OldPurchaseVerificationData oldPurchaseVerificationData =
        OldPurchaseVerificationData();
    OldPurchaseWrapper oldPurchaseWrapper = OldPurchaseWrapper();
    OldPurchaseStatus oldPurchaseStatus = OldPurchaseStatus();
    Map<String, String>? header = <String, String>{};
    Map<String, dynamic>? body = <String, int>{};
    Map<String, dynamic>? playStorePurchaseData = <String, dynamic>{};

    header = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };

    if (Platform.isAndroid && oldPurchaseDetails != null) {
      oldPurchaseVerificationData.localVerificationData =
          oldPurchaseDetails.verificationData.localVerificationData;
      oldPurchaseVerificationData.serverVerificationData =
          oldPurchaseDetails.verificationData.serverVerificationData;
      oldPurchaseVerificationData.source =
          oldPurchaseDetails.verificationData.source;

      oldPurchaseStatus.index = oldPurchaseDetails.status.index;
      oldPurchaseStatus.name = oldPurchaseDetails.status.name;

      oldPurchaseWrapper.orderId =
          oldPurchaseDetails.billingClientPurchase.orderId;
      oldPurchaseWrapper.packageName =
          oldPurchaseDetails.billingClientPurchase.packageName;
      oldPurchaseWrapper.purchaseTime =
          oldPurchaseDetails.billingClientPurchase.purchaseTime;
      oldPurchaseWrapper.purchaseToken =
          oldPurchaseDetails.billingClientPurchase.purchaseToken;
      oldPurchaseWrapper.signature =
          oldPurchaseDetails.billingClientPurchase.signature;
      oldPurchaseWrapper.isAutoRenewing =
          oldPurchaseDetails.billingClientPurchase.isAutoRenewing;
      oldPurchaseWrapper.originalJson =
          oldPurchaseDetails.billingClientPurchase.originalJson;
      oldPurchaseWrapper.developerPayload =
          oldPurchaseDetails.billingClientPurchase.developerPayload;
      oldPurchaseWrapper.isAcknowledged =
          oldPurchaseDetails.billingClientPurchase.isAcknowledged;
      oldPurchaseWrapper.oldPurchaseStatus = oldPurchaseStatus;
      oldPurchaseWrapper.obfuscatedAccountId =
          oldPurchaseDetails.billingClientPurchase.obfuscatedAccountId;
      oldPurchaseWrapper.obfuscatedProfileId =
          oldPurchaseDetails.billingClientPurchase.obfuscatedProfileId;
      oldPurchaseWrapper.lstSku = oldPurchaseDetails.billingClientPurchase.skus;

      playStorePurchaseData = {
        'purchaseId': oldPurchaseDetails.purchaseID,
        'productId': oldPurchaseDetails.productID,
        'oldPlayStorePurchase': oldPurchaseVerificationData.toJson(),
        'transactionDate': oldPurchaseDetails.transactionDate,
        'oldPurchaseStatus': oldPurchaseStatus.toJson(),
        'error': oldPurchaseDetails.error?.message,
        'pendingCompletePurchase': oldPurchaseDetails.pendingCompletePurchase,
        'oldPurchaseWrapper': oldPurchaseWrapper.toJson()
      };
    }

    debugPrint("Header token ====> $token");

    body = {
      'oldPlan': oldPlan,
      'newPlan': newPlan,
      if (Platform.isAndroid) 'playStorePurchaseData': playStorePurchaseData
    };

    apiProvider
        .put(apiurl: ApiUrl.updateSubscription, header: header, body: body)
        .then((value) async {
      if (value.statusCode == 200) {
        CommonUtils().stopLoading(Get.context!);
        var response = jsonDecode(value.body);
        debugPrint("PurchaseCompletion ===> ${response}");
        UpgradeAndDowngradePlan upgradeAndDowngradePlan =
            UpgradeAndDowngradePlan.fromJson(response);

        UserTbl tbl = UserTbl();
        UserNewModel model = await tbl.getCurrentNewUserByUID(
            FirebaseFirestore.instance, CommonUtils().auth.currentUser!.uid);
        PreferenceUtils.setUserModelData = model;

        Get.back();

        if (!upgradeAndDowngradePlan.success) {
          PreferenceUtils.setBoostUser =
              upgradeAndDowngradePlan.canBoostProfile;
          PreferenceUtils.getStartModelData?.currentSubscriptionPlan =
              upgradeAndDowngradePlan.currentSubscriptionPlanModel!;

          //update Setting view
          SettingView settingView = SettingView();
          settingView.getPlanDetails(
              planId: upgradeAndDowngradePlan
                  .currentSubscriptionPlanModel!.plan!.id!,
              isForceUpdate: true);

          //update like view
          LikeView likeView = LikeView();
          likeView.updateLikeView();

          //update home view
          WelcomeController welcomeController = WelcomeController();
          await welcomeController.manageDataBasedOnSubscriptionType(
              upgradeAndDowngradePlan.currentSubscriptionPlanModel);
          CardProvider cardProvider = CardProvider();
          cardProvider.afterInAppPurchaseUpdateView();
        }
      } else if (value.statusCode == 404) {
        CommonUtils().stopLoading(Get.context!);
        WidgetHelper().showMessage(msg: StringsNameUtils.notFound);
      } else if (value.statusCode == 403) {
        CommonUtils().stopLoading(Get.context!);
        WidgetHelper().showMessage(msg: StringsNameUtils.badRequest);
      } else if (value.statusCode == 401) {
        CommonUtils().stopLoading(Get.context!);
        WidgetHelper().showMessage(msg: StringsNameUtils.unAuthorised);
      }
    });
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
