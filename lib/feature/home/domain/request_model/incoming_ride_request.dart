import 'dart:convert';

class IncomingRideRequest {
  static const double _mileConversionFactor = 0.621371;

  final String rideId;
  final String pickupAddress;
  final String dropoffAddress;
  final double? totalFare;
  final double? distanceMiles;
  final String? customerName;
  final String? customerPhone;
  final String? customerImage;
  final double? customerRating;

  // NEW:
  final String? senderId;
  final String? receiverId;

  IncomingRideRequest({
    required this.rideId,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.totalFare,
    this.distanceMiles,
    this.customerName,
    this.customerPhone,
    this.customerImage,
    this.customerRating,
    this.senderId,
    this.receiverId,
  });

  String get fareText =>
      totalFare != null ? '\$${totalFare!.toStringAsFixed(2)}' : '';

  String? get distanceText {
    if (distanceMiles == null) return null;
    return '${distanceMiles!.toStringAsFixed(1)} mi';
  }

  factory IncomingRideRequest.fromSocket(dynamic raw) {
    Map<String, dynamic> data;
    if (raw is String) {
      data = Map<String, dynamic>.from(jsonDecode(raw));
    } else if (raw is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(raw);
    } else if (raw is Map) {
      data = raw.map((key, value) => MapEntry(key.toString(), value));
    } else {
      throw Exception(
        'Unsupported ride_request payload type: ${raw.runtimeType}',
      );
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
          pickup['address']?.toString() ??
          pickup['name']?.toString() ??
          'Pickup location',
      dropoffAddress:
          dropoff['address']?.toString() ??
          dropoff['name']?.toString() ??
          'Destination',
      totalFare: rawFare != null ? double.tryParse(rawFare.toString()) : null,
      distanceMiles: rawDistance != null
          ? (double.tryParse(rawDistance.toString()) ?? 0) *
                _mileConversionFactor
          : null,
      customerName: data['customerName']?.toString(),
      customerPhone: data['customerPhone']?.toString(),
      customerImage: data['customerImage']?.toString(),
      customerRating: data['customerRating'] != null
          ? double.tryParse(data['customerRating'].toString())
          : null,

      // NEW:
      senderId: data['senderId']?.toString(),
      receiverId: data['receiverId']?.toString(),
    );
  }
}
