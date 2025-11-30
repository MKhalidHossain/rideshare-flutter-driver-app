class ToggleOnlineStatusResponseModel {
  final bool? success;
  final String? message;
  final OnlineStatusData? data;

  ToggleOnlineStatusResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory ToggleOnlineStatusResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ToggleOnlineStatusResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : OnlineStatusData.fromJson(
              json['data'] as Map<String, dynamic>,
            ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}

class OnlineStatusData {
  final bool isOnline;
  final bool isAvailable;

  OnlineStatusData({
    required this.isOnline,
    required this.isAvailable,
  });

  factory OnlineStatusData.fromJson(Map<String, dynamic> json) {
    return OnlineStatusData(
      isOnline: (json['isOnline'] as bool?) ?? false,
      isAvailable: (json['isAvailable'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOnline': isOnline,
      'isAvailable': isAvailable,
    };
  }
}
