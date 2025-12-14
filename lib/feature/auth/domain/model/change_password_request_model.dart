class ChangePasswordRequestModel {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequestModel({
    required this.currentPassword,
    required this.newPassword,
  });

  factory ChangePasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordRequestModel(
      currentPassword: json['currentPassword'] ?? '',
      newPassword: json['newPassword'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}
