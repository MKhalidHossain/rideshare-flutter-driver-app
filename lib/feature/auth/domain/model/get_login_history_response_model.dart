class GetLoginHistoryResponseModel {
  bool? success;
  String? message;
  List<LoginHistory>? loginHistory;

  GetLoginHistoryResponseModel({
    this.success,
    this.message,
    this.loginHistory,
  });

  factory GetLoginHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    // Support both top-level list and nested data.loginHistory
    List<LoginHistory>? parseList(dynamic raw) {
      if (raw is List) {
        return raw.map((e) => LoginHistory.fromJson(e)).toList();
      }
      return [];
    }

    final data = json['data'];
    final listFromData = (data is Map<String, dynamic>) ? data['loginHistory'] : null;
    final listFromRoot = json['loginHistory'];

    return GetLoginHistoryResponseModel(
      success: json['success'],
      message: json['message'],
      loginHistory: parseList(listFromData ?? listFromRoot),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'loginHistory': loginHistory?.map((e) => e.toJson()).toList(),
    };
  }
}

class LoginHistory {
  String? device;
  String? ipAddress;
  String? id;
  DateTime? loginTime;

  LoginHistory({
    this.device,
    this.ipAddress,
    this.id,
    this.loginTime,
  });

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
      device: json['device'],
      ipAddress: json['ipAddress'],
      id: json['_id'],
      loginTime: json['loginTime'] != null
          ? DateTime.parse(json['loginTime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device': device,
      'ipAddress': ipAddress,
      '_id': id,
      'loginTime': loginTime?.toIso8601String(),
    };
  }
}
