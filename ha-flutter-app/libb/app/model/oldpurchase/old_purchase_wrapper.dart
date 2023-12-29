import 'package:hepy/app/model/oldpurchase/old_purchase_status.dart';

class OldPurchaseWrapper{
  String? orderId;
  String? packageName;
  int? purchaseTime;
  String? purchaseToken;
  String? signature;
  bool? isAutoRenewing;
  String? originalJson;
  String? developerPayload;
  bool? isAcknowledged;
  OldPurchaseStatus? oldPurchaseStatus;
  String? obfuscatedAccountId;
  String? obfuscatedProfileId;
  List<dynamic>?lstSku;

  OldPurchaseWrapper(
      {this.orderId,
      this.packageName,
      this.purchaseTime,
      this.purchaseToken,
      this.signature,
      this.isAutoRenewing,
      this.originalJson,
      this.developerPayload,
      this.isAcknowledged,
      this.oldPurchaseStatus,
      this.obfuscatedAccountId,
      this.obfuscatedProfileId,
      this.lstSku});

  factory OldPurchaseWrapper. fromJson(Map<String, dynamic> json){
    return OldPurchaseWrapper(
      orderId: json['orderId'],
      packageName: json['packageName'],
      purchaseTime: json['purchaseTime'],
      purchaseToken: json['purchaseToken'],
      signature: json['signature'],
      lstSku: json['skus'],
      isAutoRenewing: json['isAutoRenewing'],
      originalJson: json['originalJson'],
      developerPayload: json['developerPayload'],
      isAcknowledged: json['isAcknowledged'],
      oldPurchaseStatus: json['oldPurchaseStatus'] != null
          ? OldPurchaseStatus.fromJson(json)
          : null,
      obfuscatedAccountId: json['obfuscatedAccountId'],
      obfuscatedProfileId: json['obfuscatedProfileId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId':orderId,
      'packageName':packageName,
      'purchaseTime':purchaseTime,
      'purchaseToken':purchaseToken,
      'signature':signature,
      'isAutoRenewing':isAutoRenewing,
      'originalJson':originalJson,
      'developerPayload':developerPayload,
      'isAcknowledged':isAcknowledged,
      'oldPurchaseStatus':OldPurchaseStatus().toJson(),
      'obfuscatedAccountId':obfuscatedAccountId,
      'obfuscatedProfileId':obfuscatedProfileId,
      'skus':lstSku,
    };
  }
}