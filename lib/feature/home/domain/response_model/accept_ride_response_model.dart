import 'dart:convert';

AcceptRideResponseModel acceptRideResponseModelFromJson(String str) =>
    AcceptRideResponseModel.fromJson(json.decode(str));

String acceptRideResponseModelToJson(AcceptRideResponseModel data) =>
    json.encode(data.toJson());

class AcceptRideResponseModel {
  final bool? success;
  final String? message;
  final AcceptRideData? data;
  final AcceptRideNotification? notification;

  AcceptRideResponseModel({
    this.success,
    this.message,
    this.data,
    this.notification,
  });

  factory AcceptRideResponseModel.fromJson(Map<String, dynamic> json) {
    // Detect the "flat" payload (your sample JSON)
    final bool isFlatPayload =
        json['data'] == null &&
        json['rideId'] != null &&
        json['pickup'] != null &&
        json['dropoff'] != null;

    return AcceptRideResponseModel(
      success: json['success'] ?? (isFlatPayload ? true : false),
      message: json['message'] ?? '',
      data: isFlatPayload
          ? AcceptRideData.fromJson(json) // use the whole flat JSON as data
          : (json['data'] != null
              ? AcceptRideData.fromJson(json['data'])
              : null),
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
  final String totalFare;
  final CustomerInfo customerInfo;

  AcceptRideData({
    required this.rideId,
    required this.totalFare,
    required this.customerInfo,
  });

  factory AcceptRideData.fromJson(Map<String, dynamic> json) {
    return AcceptRideData(
      rideId: json['rideId'] ?? '',
      totalFare: json['totalFare']?.toString() ?? '',
      // If backend nests `customerInfo`, use that; otherwise
      // treat the whole JSON as the customer info container
      customerInfo: json['customerInfo'] != null
          ? CustomerInfo.fromJson(json['customerInfo'])
          : CustomerInfo.fromJson(json),
    );
  }

  Map<String, dynamic> toJson() => {
        'rideId': rideId,
        'totalFare': totalFare,
        'customerInfo': customerInfo.toJson(),
      };
}

class CustomerInfo {
  final RideLocation pickup;
  final RideLocation dropoff;
  final String userName;
  final String userPhone;
  final String? userPhoto;
  final double? userRating;

  CustomerInfo({
    required this.pickup,
    required this.dropoff,
    required this.userName,
    required this.userPhone,
    this.userPhoto,
    this.userRating,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) {
    final ratingRaw =
        json['userRating'] ?? json['customerRating'] ?? json['rating'];

    return CustomerInfo(
      pickup: RideLocation.fromJson(json['pickup'] ?? {}),
      dropoff: RideLocation.fromJson(json['dropoff'] ?? {}),
      userName: json['userName'] ??
          json['customerName'] ??
          json['name'] ??
          json['driverName'] ??
          '',
      userPhone: json['userPhone'] ??
          json['customerPhone'] ??
          json['phone'] ??
          json['driverPhone'] ??
          '',
      userPhoto: json['userPhoto'] ??
          json['customerPhoto'] ??
          json['customerImage'] ?? // <-- handles your sample JSON
          json['photo'],
      userRating:
          ratingRaw != null ? double.tryParse(ratingRaw.toString()) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'pickup': pickup.toJson(),
        'dropoff': dropoff.toJson(),
        'userName': userName,
        'userPhone': userPhone,
        'userPhoto': userPhoto,
        'userRating': userRating,
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






// import 'dart:convert';

// AcceptRideResponseModel acceptRideResponseModelFromJson(String str) =>
//     AcceptRideResponseModel.fromJson(json.decode(str));

// String acceptRideResponseModelToJson(AcceptRideResponseModel data) =>
//     json.encode(data.toJson());

// class AcceptRideResponseModel {
//   final bool? success;
//   final String ?message;
//   final AcceptRideData? data;
//   final AcceptRideNotification? notification;

//   AcceptRideResponseModel({
//      this.success,
//      this.message,
//     this.data,
//     this.notification,
//   });

//   factory AcceptRideResponseModel.fromJson(Map<String, dynamic> json) {
//     return AcceptRideResponseModel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] != null
//           ? AcceptRideData.fromJson(json['data'])
//           : null,
//       notification: json['notification'] != null
//           ? AcceptRideNotification.fromJson(json['notification'])
//           : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'success': success,
//         'message': message,
//         'data': data?.toJson(),
//         'notification': notification?.toJson(),
//       };
// }

// class AcceptRideData {
//   final String rideId;
//   final CustomerInfo customerInfo;

//   AcceptRideData({
//     required this.rideId,
//     required this.customerInfo,
//   });

//   factory AcceptRideData.fromJson(Map<String, dynamic> json) {
//     return AcceptRideData(
//       rideId: json['rideId'] ?? '',
//       customerInfo: CustomerInfo.fromJson(json['customerInfo'] ?? {}),
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'rideId': rideId,
//         'customerInfo': customerInfo.toJson(),
//       };
// }

// class CustomerInfo {
//   final RideLocation pickup;
//   final RideLocation dropoff;
//   final String userName;
//   final String userPhone;
//   final String? userPhoto;
//   final double? userRating;

//   CustomerInfo({
//     required this.pickup,
//     required this.dropoff,
//     required this.userName,
//     required this.userPhone,
//     this.userPhoto,
//     this.userRating,
//   });

//   factory CustomerInfo.fromJson(Map<String, dynamic> json) {
//     final ratingRaw =
//         json['userRating'] ?? json['customerRating'] ?? json['rating'];
//     return CustomerInfo(
//       pickup: RideLocation.fromJson(json['pickup'] ?? {}),
//       dropoff: RideLocation.fromJson(json['dropoff'] ?? {}),
//       userName: json['userName'] ??
//           json['customerName'] ??
//           json['name'] ??
//           json['driverName'] ??
//           '',
//       userPhone: json['userPhone'] ??
//           json['customerPhone'] ??
//           json['phone'] ??
//           json['driverPhone'] ??
//           '',
//       userPhoto: json['userPhoto'] ?? json['customerPhoto'] ?? json['photo'],
//       userRating:
//           ratingRaw != null ? double.tryParse(ratingRaw.toString()) : null,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'pickup': pickup.toJson(),
//         'dropoff': dropoff.toJson(),
//         'userName': userName,
//         'userPhone': userPhone,
//         'userPhoto': userPhoto,
//         'userRating': userRating,
//       };
// }

// class RideLocation {
//   final List<double> coordinates;
//   final String address;
//   final String type;

//   RideLocation({
//     required this.coordinates,
//     required this.address,
//     required this.type,
//   });

//   factory RideLocation.fromJson(Map<String, dynamic> json) {
//     return RideLocation(
//       coordinates: (json['coordinates'] as List<dynamic>? ?? [])
//           .map((e) => (e as num).toDouble())
//           .toList(),
//       address: json['address'] ?? '',
//       type: json['type'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'coordinates': coordinates,
//         'address': address,
//         'type': type,
//       };
// }

// class AcceptRideNotification {
//   final String senderId;
//   final String receiverId;
//   final String title;
//   final String message;
//   final String type;
//   final bool isRead;
//   final String id;
//   final String createdAt;
//   final int v;

//   AcceptRideNotification({
//     required this.senderId,
//     required this.receiverId,
//     required this.title,
//     required this.message,
//     required this.type,
//     required this.isRead,
//     required this.id,
//     required this.createdAt,
//     required this.v,
//   });

//   factory AcceptRideNotification.fromJson(Map<String, dynamic> json) {
//     return AcceptRideNotification(
//       senderId: json['senderId'] ?? '',
//       receiverId: json['receiverId'] ?? '',
//       title: json['title'] ?? '',
//       message: json['message'] ?? '',
//       type: json['type'] ?? '',
//       isRead: json['isRead'] ?? false,
//       id: json['_id'] ?? '',
//       createdAt: json['createdAt'] ?? '',
//       v: json['__v'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//         'senderId': senderId,
//         'receiverId': receiverId,
//         'title': title,
//         'message': message,
//         'type': type,
//         'isRead': isRead,
//         '_id': id,
//         'createdAt': createdAt,
//         '__v': v,
//       };
// }
