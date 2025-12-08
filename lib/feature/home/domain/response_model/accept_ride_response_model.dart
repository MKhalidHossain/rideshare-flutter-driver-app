import 'dart:convert';

AcceptRideResponseModel acceptRideResponseModelFromJson(String str) =>
    AcceptRideResponseModel.fromJson(json.decode(str));

String acceptRideResponseModelToJson(AcceptRideResponseModel data) =>
    json.encode(data.toJson());

class AcceptRideResponseModel {
  final bool? success;
  final String ?message;
  final AcceptRideData? data;
  final AcceptRideNotification? notification;

  AcceptRideResponseModel({
     this.success,
     this.message,
    this.data,
    this.notification,
  });

  factory AcceptRideResponseModel.fromJson(Map<String, dynamic> json) {
    return AcceptRideResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? AcceptRideData.fromJson(json['data'])
          : null,
      notification: json['notification'] != null
          ? AcceptRideNotification.fromJson(json['notification'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
        'notification': notification?.toJson(),
      };
}

class AcceptRideData {
  final String rideId;
  final CustomerInfo customerInfo;

  AcceptRideData({
    required this.rideId,
    required this.customerInfo,
  });

  factory AcceptRideData.fromJson(Map<String, dynamic> json) {
    return AcceptRideData(
      rideId: json['rideId'] ?? '',
      customerInfo: CustomerInfo.fromJson(json['customerInfo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'rideId': rideId,
        'customerInfo': customerInfo.toJson(),
      };
}

class CustomerInfo {
  final RideLocation pickup;
  final RideLocation dropoff;
  final String driverName;
  final String driverPhone;

  CustomerInfo({
    required this.pickup,
    required this.dropoff,
    required this.driverName,
    required this.driverPhone,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      pickup: RideLocation.fromJson(json['pickup'] ?? {}),
      dropoff: RideLocation.fromJson(json['dropoff'] ?? {}),
      driverName: json['driverName'] ?? '',
      driverPhone: json['driverPhone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'pickup': pickup.toJson(),
        'dropoff': dropoff.toJson(),
        'driverName': driverName,
        'driverPhone': driverPhone,
      };
}

class RideLocation {
  final List<double> coordinates;
  final String address;
  final String type;

  RideLocation({
    required this.coordinates,
    required this.address,
    required this.type,
  });

  factory RideLocation.fromJson(Map<String, dynamic> json) {
    return RideLocation(
      coordinates: (json['coordinates'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      address: json['address'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
        'address': address,
        'type': type,
      };
}

class AcceptRideNotification {
  final String senderId;
  final String receiverId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String id;
  final String createdAt;
  final int v;

  AcceptRideNotification({
    required this.senderId,
    required this.receiverId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.id,
    required this.createdAt,
    required this.v,
  });

  factory AcceptRideNotification.fromJson(Map<String, dynamic> json) {
    return AcceptRideNotification(
      senderId: json['senderId'] ?? '',
      receiverId: json['receiverId'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      id: json['_id'] ?? '',
      createdAt: json['createdAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'senderId': senderId,
        'receiverId': receiverId,
        'title': title,
        'message': message,
        'type': type,
        'isRead': isRead,
        '_id': id,
        'createdAt': createdAt,
        '__v': v,
      };
}
