class CancelRideResponseModel {
  final bool ?success;
  final String? message;

  CancelRideResponseModel({
     this.success,
     this.message,
  });

  factory CancelRideResponseModel.fromJson(Map<String, dynamic> json) {
    return CancelRideResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
