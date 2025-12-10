import 'dart:convert';

class IncomingRideRequest {
  final String rideId;
  final String pickupAddress;
  final String dropoffAddress;
  final double? totalFare;
  final double? distanceKm;
  final String? customerName;
  final String? customerPhone;
  final String? customerImage;
  final double? customerRating;

  IncomingRideRequest({
    required this.rideId,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.totalFare,
    this.distanceKm,
    this.customerName,
    this.customerPhone,
    this.customerImage,
    this.customerRating,
  });

  String get fareText =>
      totalFare != null ? '\$${totalFare!.toStringAsFixed(2)}' : '';

  String? get distanceText =>
      distanceKm != null ? '${distanceKm!.toStringAsFixed(1)} km' : null;

  factory IncomingRideRequest.fromSocket(dynamic raw) {
    Map<String, dynamic> data;
    if (raw is String) {
      data = Map<String, dynamic>.from(jsonDecode(raw));
    } else if (raw is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(raw);
    } else if (raw is Map) {
      data = raw.map((key, value) => MapEntry(key.toString(), value));
    } else {
      throw Exception('Unsupported ride_request payload type: ${raw.runtimeType}');
    }

    final pickup = data['pickup'] is Map
        ? Map<String, dynamic>.from(data['pickup'])
        : <String, dynamic>{};
    final dropoff = data['dropoff'] is Map
        ? Map<String, dynamic>.from(data['dropoff'])
        : <String, dynamic>{};

    final rawFare = data['totalFare'];
    final rawDistance = data['distance'];

    return IncomingRideRequest(
      rideId: data['rideId']?.toString() ?? '',
      pickupAddress:
          pickup['address']?.toString() ?? pickup['name']?.toString() ?? 'Pickup location',
      dropoffAddress:
          dropoff['address']?.toString() ?? dropoff['name']?.toString() ?? 'Destination',
      totalFare: rawFare != null ? double.tryParse(rawFare.toString()) : null,
      distanceKm:
          rawDistance != null ? double.tryParse(rawDistance.toString()) : null,
      customerName: data['customerName']?.toString(),
      customerPhone: data['customerPhone']?.toString(),
      customerImage: data['customerImage']?.toString(),
      customerRating: data['customerRating'] != null
          ? double.tryParse(data['customerRating'].toString())
          : null,
    );
  }
}
