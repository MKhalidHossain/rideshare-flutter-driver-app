class UpdateDriverLocationRequestModel {
  final double latitude;
  final double longitude;
  final double? heading;
  final double? speed;
  final String? rideId;

  UpdateDriverLocationRequestModel({
    required this.latitude,
    required this.longitude,
    this.heading,
    this.speed,
    this.rideId,
  });

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'heading': heading,
      'speed': speed,
      if (rideId != null && rideId!.isNotEmpty) 'rideId': rideId,
    };
  }
}
