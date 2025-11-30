class UpdateDriverLocationResponesModel {
  final bool ?success;
  final String ?message;
  final DriverLocationData ?data;

  UpdateDriverLocationResponesModel({
     this.success,
     this.message,
     this.data,
  });

  factory UpdateDriverLocationResponesModel.fromJson(
      Map<String, dynamic> json) {
    return UpdateDriverLocationResponesModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: DriverLocationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data!.toJson(),
    };
  }
}

class DriverLocationData {
  final DriverLocation location;

  DriverLocationData({
    required this.location,
  });

  factory DriverLocationData.fromJson(Map<String, dynamic> json) {
    return DriverLocationData(
      location:
          DriverLocation.fromJson(json['location'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
    };
  }
}

class DriverLocation {
  final double latitude;
  final double longitude;

  DriverLocation({
    required this.latitude,
    required this.longitude,
  });

  factory DriverLocation.fromJson(Map<String, dynamic> json) {
    return DriverLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
