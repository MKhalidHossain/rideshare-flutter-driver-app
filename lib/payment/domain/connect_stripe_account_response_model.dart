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
    final dynamic data = json['data'];
    final Map<String, dynamic>? dataMap =
        data is Map<String, dynamic> ? data : null;

    final dynamic rawSuccess = json['success'] ?? json['status'];
    final bool success = rawSuccess == true ||
        rawSuccess == 1 ||
        rawSuccess == 'success' ||
        rawSuccess == 'true';

    final String? message = (json['message'] ?? json['error']) as String?;
    final String? accountId = (json['accountId'] ??
        json['stripeAccountId'] ??
        json['stripe_account_id']) as String?;
    final String? url = (json['url'] ??
        json['link'] ??
        json['accountLink'] ??
        json['account_link'] ??
        json['onboardingUrl'] ??
        json['onboarding_url'] ??
        dataMap?['url'] ??
        dataMap?['link'] ??
        dataMap?['accountLink'] ??
        dataMap?['account_link'] ??
        dataMap?['onboardingUrl'] ??
        dataMap?['onboarding_url']) as String?;

    return ConnectStripeAccountResponseModel(
      success: success,
      accountId: accountId,
      message: message,
      url: url,
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
