class UpdateDriverLocationResponesModel {
  final bool? success;
  final String? message;
  final DriverLocationData? data;

  UpdateDriverLocationResponesModel({
     this.success,
     this.message,
     this.data,
  });

  factory UpdateDriverLocationResponesModel.fromJson(
      Map<String, dynamic> json) {
    return UpdateDriverLocationResponesModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? DriverLocationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class DriverLocationData {
  final String? driverId;
  final DriverLocation? location;
  final double? heading;
  final double? speed;

  DriverLocationData({
    this.driverId,
    this.location,
    this.heading,
    this.speed,
  });

  factory DriverLocationData.fromJson(Map<String, dynamic> json) {
    return DriverLocationData(
      driverId: json['driverId']?.toString(),
      location: json['location'] is Map<String, dynamic>
          ? DriverLocation.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      heading: (json['heading'] as num?)?.toDouble(),
      speed: (json['speed'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'location': location?.toJson(),
      'heading': heading,
      'speed': speed,
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
