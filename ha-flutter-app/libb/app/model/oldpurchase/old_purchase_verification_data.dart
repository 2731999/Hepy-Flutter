class OldPurchaseVerificationData{
  String? localVerificationData;
  String? serverVerificationData;
  String? source;

  OldPurchaseVerificationData(
      {this.localVerificationData, this.serverVerificationData, this.source});

  factory OldPurchaseVerificationData.fromJson(Map<String, dynamic> json){
    return OldPurchaseVerificationData(
      localVerificationData: json['localVerificationData'],
      serverVerificationData: json['serverVerificationData'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'localVerificationData':localVerificationData,
      'serverVerificationData':serverVerificationData,
      'source':source,
    };
  }
}