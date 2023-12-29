import 'package:hepy/app/model/oldpurchase/old_purchase_wrapper.dart';

import 'old_purchase_status.dart';
import 'old_purchase_verification_data.dart';

class OldPlayStorePurchase {
  String? purchaseID;
  String? productID;
  OldPurchaseVerificationData? oldPlayStorePurchase;
  String? transactionDate;
  OldPurchaseStatus? oldStatus;
  String? error;
  bool? pendingCompletePurchase;
  OldPurchaseWrapper? oldPurchaseWrapper;

  OldPlayStorePurchase(
      {this.purchaseID,
      this.productID,
      this.oldPlayStorePurchase,
      this.transactionDate,
      this.oldStatus,
      this.error,
      this.pendingCompletePurchase,
      this.oldPurchaseWrapper});

  factory OldPlayStorePurchase.fromJson(Map<String, dynamic> json) {
    return OldPlayStorePurchase(
        purchaseID: json['purchaseId'],
        productID: json['productId'],
        oldPlayStorePurchase: json['oldPlayStorePurchase'] != null
            ? OldPurchaseVerificationData.fromJson(json['oldPlayStorePurchase'])
            : null,
        transactionDate: json['transactionDate'],
        oldStatus: json['oldPurchaseStatus'] != null
            ? OldPurchaseStatus.fromJson(json['oldPurchaseStatus'])
            : null,
        error: json['error'],
        pendingCompletePurchase: json['pendingCompletePurchase'],
        oldPurchaseWrapper: json['oldPurchaseWrapper'] != null
            ? OldPurchaseWrapper.fromJson(json['oldPurchaseWrapper'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'purchaseID': purchaseID,
      'productID': productID,
      'oldPlayStorePurchase': OldPurchaseVerificationData().toJson(),
      'transactionDate': transactionDate,
      'oldPurchaseStatus': OldPurchaseStatus().toJson(),
      'error': error,
      'pendingCompletePurchase': pendingCompletePurchase,
      'oldPurchaseWrapper': OldPurchaseWrapper().toJson(),
    };
  }
}
