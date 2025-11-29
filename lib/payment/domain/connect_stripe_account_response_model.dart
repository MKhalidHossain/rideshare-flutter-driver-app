class ConnectStripeAccountResponseModel {
  final bool success;
  final String? accountId;
  final String? message;
  final String? url;

  ConnectStripeAccountResponseModel({
    required this.success,
    this.accountId,
    this.message,
    this.url,
  });

  factory ConnectStripeAccountResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ConnectStripeAccountResponseModel(
      success: json['success'] == true,
      accountId: json['accountId'] as String?,
      message: json['message'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'accountId': accountId,
      'message': message,
      'url': url,
    };
  }
}
