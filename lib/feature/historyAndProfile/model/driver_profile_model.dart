/*
class DriverProfileModel {
  final bool success;
  final DriverData data;

  DriverProfileModel({required this.success, required this.data});

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      success: json['success'] ?? false,
      data: DriverData.fromJson(json['data'] ?? {}),
    );
  }
}

class DriverData {
  final Vehicle vehicle;
  final CurrentLocation currentLocation;
  final Ratings ratings;
  final Earnings earnings;
  final EmergencyContact emergencyContact;
  final String id;
  final User user;
  final String licenseNumber;
  final String licenseImage;
  final String nidNumber;
  final String nidImage;
  final String selfieImage;
  final List<ServiceType> serviceTypes;
  final String status;
  final bool isOnline;
  final bool isAvailable;
  final String city;
  final String state;
  final String streetAddress;
  final String zipcode;
  final String dateOfBirth;

  DriverData({
    required this.vehicle,
    required this.currentLocation,
    required this.ratings,
    required this.earnings,
    required this.emergencyContact,
    required this.id,
    required this.user,
    required this.licenseNumber,
    required this.licenseImage,
    required this.nidNumber,
    required this.nidImage,
    required this.selfieImage,
    required this.serviceTypes,
    required this.status,
    required this.isOnline,
    required this.isAvailable,
    required this.city,
    required this.state,
    required this.streetAddress,
    required this.zipcode,
    required this.dateOfBirth,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
      currentLocation:
      CurrentLocation.fromJson(json['currentLocation'] ?? {'type': '', 'coordinates': [0, 0]}),
      ratings: Ratings.fromJson(json['ratings'] ?? {}),
      earnings: Earnings.fromJson(json['earnings'] ?? {}),
      emergencyContact:
      EmergencyContact.fromJson(json['emergency_contact'] ?? {'name': '', 'phoneNumber': ''}),
      id: json['_id'] ?? '',
      user: User.fromJson(json['userId'] ?? {}),
      licenseNumber: json['licenseNumber'] ?? '',
      licenseImage: json['licenseImage'] ?? '',
      nidNumber: json['nidNumber'] ?? '',
      nidImage: json['nidImage'] ?? '',
      selfieImage: json['selfieImage'] ?? '',
      serviceTypes: (json['serviceTypes'] as List? ?? [])
          .map((e) => ServiceType.fromJson(e))
          .toList(),
      status: json['status'] ?? '',
      isOnline: json['isOnline'] ?? false,
      isAvailable: json['isAvailable'] ?? false,
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      streetAddress: json['street_address'] ?? '',
      zipcode: json['zipcode'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
    );
  }
}

class Vehicle {
  final String type;
  final String model;
  final int year;
  final String plateNumber;
  final String color;
  final String image;

  Vehicle({
    required this.type,
    required this.model,
    required this.year,
    required this.plateNumber,
    required this.color,
    required this.image,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      type: json['type'] ?? '',
      model: json['model'] ?? '',
      year: json['year'] ?? 0,
      plateNumber: json['plateNumber'] ?? '',
      color: json['color'] ?? '',
      image: json['image'] ?? '',
    );
  }
}

class CurrentLocation {
  final String type;
  final List<double> coordinates;

  CurrentLocation({required this.type, required this.coordinates});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'] ?? '',
      coordinates: (json['coordinates'] as List? ?? [0, 0])
          .map((x) => (x as num).toDouble())
          .toList(),
    );
  }
}

class Ratings {
  final double average;
  final int count;

  Ratings({required this.average, required this.count});

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      average: (json['average'] ?? 0).toDouble(),
      count: json['count'] ?? 0,
    );
  }
}

class Earnings {
  final double total;
  final double available;
  final double withdrawn;

  Earnings({required this.total, required this.available, required this.withdrawn});

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      total: (json['total'] ?? 0).toDouble(),
      available: (json['available'] ?? 0).toDouble(),
      withdrawn: (json['withdrawn'] ?? 0).toDouble(),
    );
  }
}

class EmergencyContact {
  final String name;
  final String phoneNumber;

  EmergencyContact({required this.name, required this.phoneNumber});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String profileImage;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profileImage: json['profileImage'] ?? '',
    );
  }
}

class ServiceType {
  final String id;
  final String name;

  ServiceType({required this.id, required this.name});

  factory ServiceType.fromJson(Map<String, dynamic> json) {
    return ServiceType(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}
*/
import 'dart:convert';

DriverProfileResponse driverProfileResponseFromJson(String str) =>
    DriverProfileResponse.fromJson(json.decode(str));

String driverProfileResponseToJson(DriverProfileResponse data) =>
    json.encode(data.toJson());

class DriverProfileResponse {
  final bool success;
  final ProfileData? profileData;
  final DriverData? driverData;

  DriverProfileResponse({
    required this.success,
    this.profileData,
    this.driverData,
  });

  factory DriverProfileResponse.fromJson(Map<String, dynamic>? json) =>
      DriverProfileResponse(
        success: json?["success"] ?? false,
        profileData: json?["profileData"] != null
            ? ProfileData.fromJson(json!["profileData"])
            : null,
        driverData: json?["driverData"] != null
            ? DriverData.fromJson(json!["driverData"])
            : null,
      );

  Map<String, dynamic> toJson() => {
    "success": success,
    "profileData": profileData?.toJson(),
    "driverData": driverData?.toJson(),
  };
}

class ProfileData {
  final Wallet? wallet;
  final NotificationSettings? notificationSettings;
  final EmergencyContact? emergencyContact;
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String role;
  final String? profileImage;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String licenseNumber;
  final String licenseImage;
  final String nidNumber;
  final String nidImage;
  final String selfieImage;
  final List<String>? serviceTypes;
  final String? refreshToken;
  final bool isActive;
  final List<SavedPlace>? savedPlaces;
  final List<dynamic>? suspensions;
  final List<LoginHistory>? loginHistory;
  final String? lastSeen;
  final String? lastActive;
  final String? createdAt;
  final String? city;
  final String? dateOfBirth;
  final String? state;
  final String? streetAddress;
  final String? zipcode;
  final List<dynamic>? paymentMethods;

  ProfileData({
    this.wallet,
    this.notificationSettings,
    this.emergencyContact,
    this.id = '',
    this.fullName = '',
    this.email = '',
    this.phoneNumber = '',
    this.role = '',
    this.profileImage,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.licenseNumber = '',
    this.licenseImage = '',
    this.nidNumber = '',
    this.nidImage = '',
    this.selfieImage = '',
    this.serviceTypes,
    this.refreshToken,
    this.isActive = false,
    this.savedPlaces,
    this.suspensions,
    this.loginHistory,
    this.lastSeen,
    this.lastActive,
    this.createdAt,
    this.city,
    this.dateOfBirth,
    this.state,
    this.streetAddress,
    this.zipcode,
    this.paymentMethods,
  });

  factory ProfileData.fromJson(Map<String, dynamic>? json) => ProfileData(
    wallet:
    json?["wallet"] != null ? Wallet.fromJson(json!["wallet"]) : null,
    notificationSettings: json?["notificationSettings"] != null
        ? NotificationSettings.fromJson(json!["notificationSettings"])
        : null,
    emergencyContact: json?["emergency_contact"] != null
        ? EmergencyContact.fromJson(json!["emergency_contact"])
        : null,
    id: json?["_id"] ?? '',
    fullName: json?["fullName"] ?? '',
    email: json?["email"] ?? '',
    phoneNumber: json?["phoneNumber"] ?? '',
    role: json?["role"] ?? '',
    profileImage: json?["profileImage"],
    isEmailVerified: json?["isEmailVerified"] ?? false,
    isPhoneVerified: json?["isPhoneVerified"] ?? false,
    licenseNumber: json?["licenseNumber"] ?? '',
    licenseImage: json?["licenseImage"] ?? '',
    nidNumber: json?["nidNumber"] ?? '',
    nidImage: json?["nidImage"] ?? '',
    selfieImage: json?["selfieImage"] ?? '',
    serviceTypes: json?["serviceTypes"] != null
        ? List<String>.from(json!["serviceTypes"])
        : null,
    refreshToken: json?["refreshToken"],
    isActive: json?["isActive"] ?? false,
    savedPlaces: json?["savedPlaces"] != null
        ? List<SavedPlace>.from(
        json!["savedPlaces"].map((x) => SavedPlace.fromJson(x)))
        : null,
    suspensions: json?["suspensions"] ?? [],
    loginHistory: json?["loginHistory"] != null
        ? List<LoginHistory>.from(
        json!["loginHistory"].map((x) => LoginHistory.fromJson(x)))
        : null,
    lastSeen: json?["lastSeen"],
    lastActive: json?["lastActive"],
    createdAt: json?["createdAt"],
    city: json?["city"],
    dateOfBirth: json?["date_of_birth"],
    state: json?["state"],
    streetAddress: json?["street_address"],
    zipcode: json?["zipcode"],
    paymentMethods: json?["paymentMethods"] ?? [],
  );

  Map<String, dynamic> toJson() => {
    "wallet": wallet?.toJson(),
    "notificationSettings": notificationSettings?.toJson(),
    "emergency_contact": emergencyContact?.toJson(),
    "_id": id,
    "fullName": fullName,
    "email": email,
    "phoneNumber": phoneNumber,
    "role": role,
    "profileImage": profileImage,
    "isEmailVerified": isEmailVerified,
    "isPhoneVerified": isPhoneVerified,
    "licenseNumber": licenseNumber,
    "licenseImage": licenseImage,
    "nidNumber": nidNumber,
    "nidImage": nidImage,
    "selfieImage": selfieImage,
    "serviceTypes": serviceTypes,
    "refreshToken": refreshToken,
    "isActive": isActive,
    "savedPlaces": savedPlaces?.map((x) => x.toJson()).toList(),
    "suspensions": suspensions,
    "loginHistory": loginHistory?.map((x) => x.toJson()).toList(),
    "lastSeen": lastSeen,
    "lastActive": lastActive,
    "createdAt": createdAt,
    "city": city,
    "date_of_birth": dateOfBirth,
    "state": state,
    "street_address": streetAddress,
    "zipcode": zipcode,
    "paymentMethods": paymentMethods,
  };
}

class Wallet {
  final double balance;
  final List<dynamic> transactions;

  Wallet({this.balance = 0, this.transactions = const []});

  factory Wallet.fromJson(Map<String, dynamic>? json) =>
      Wallet(balance: json?["balance"]?.toDouble() ?? 0, transactions: json?["transactions"] ?? []);

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "transactions": transactions,
  };
}

class NotificationSettings {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;

  NotificationSettings({
    this.pushNotifications = false,
    this.emailNotifications = false,
    this.smsNotifications = false,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic>? json) =>
      NotificationSettings(
        pushNotifications: json?["pushNotifications"] ?? false,
        emailNotifications: json?["emailNotifications"] ?? false,
        smsNotifications: json?["smsNotifications"] ?? false,
      );

  Map<String, dynamic> toJson() => {
    "pushNotifications": pushNotifications,
    "emailNotifications": emailNotifications,
    "smsNotifications": smsNotifications,
  };
}

class EmergencyContact {
  final String name;
  final String? phoneNumber;

  EmergencyContact({this.name = '', this.phoneNumber});

  factory EmergencyContact.fromJson(Map<String, dynamic>? json) =>
      EmergencyContact(
        name: json?["name"] ?? '',
        phoneNumber: json?["phoneNumber"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "phoneNumber": phoneNumber,
  };
}

class SavedPlace {
  final String name;
  final String address;
  final List<double>? coordinates;
  final String? type;
  final String id;

  SavedPlace({
    this.name = '',
    this.address = '',
    this.coordinates,
    this.type,
    this.id = '',
  });

  factory SavedPlace.fromJson(Map<String, dynamic>? json) => SavedPlace(
    name: json?["name"] ?? '',
    address: json?["address"] ?? '',
    coordinates: json?["coordinates"] != null
        ? List<double>.from(json!["coordinates"])
        : null,
    type: json?["type"],
    id: json?["_id"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "address": address,
    "coordinates": coordinates,
    "type": type,
    "_id": id,
  };
}

class LoginHistory {
  final String? device;
  final String? ipAddress;
  final String id;
  final String? loginTime;

  LoginHistory({
    this.device,
    this.ipAddress,
    this.id = '',
    this.loginTime,
  });

  factory LoginHistory.fromJson(Map<String, dynamic>? json) => LoginHistory(
    device: json?["device"],
    ipAddress: json?["ipAddress"],
    id: json?["_id"] ?? '',
    loginTime: json?["loginTime"],
  );

  Map<String, dynamic> toJson() => {
    "device": device,
    "ipAddress": ipAddress,
    "_id": id,
    "loginTime": loginTime,
  };
}

class DriverData {
  final CurrentLocation? currentLocation;
  final Earnings? earnings;
  final Ratings? ratings;
  final String id;
  final String userId;
  final String? vehicleId;
  final String? status;
  final bool isAvailable;
  final int? heading;
  final bool isOnline;
  final int? speed;
  final dynamic accuracy;
  final List<dynamic>? paymentMethods;
  final List<dynamic>? withdrawals;
  final int? v;
  final String? currentRideId;
  final String? stripeDriverId;
  final String? city;
  final String? dateOfBirth;
  final EmergencyContact? emergencyContact;
  final String? state;
  final String? streetAddress;
  final String? zipcode;

  DriverData({
    this.currentLocation,
    this.earnings,
    this.ratings,
    this.id = '',
    this.userId = '',
    this.vehicleId,
    this.status,
    this.isAvailable = false,
    this.heading,
    this.isOnline = false,
    this.speed,
    this.accuracy,
    this.paymentMethods,
    this.withdrawals,
    this.v,
    this.currentRideId,
    this.stripeDriverId,
    this.city,
    this.dateOfBirth,
    this.emergencyContact,
    this.state,
    this.streetAddress,
    this.zipcode,
  });

  factory DriverData.fromJson(Map<String, dynamic>? json) => DriverData(
    currentLocation: json?["currentLocation"] != null
        ? CurrentLocation.fromJson(json!["currentLocation"])
        : null,
    earnings: json?["earnings"] != null
        ? Earnings.fromJson(json!["earnings"])
        : null,
    ratings: json?["ratings"] != null
        ? Ratings.fromJson(json!["ratings"])
        : null,
    id: json?["_id"] ?? '',
    userId: json?["userId"] ?? '',
    vehicleId: json?["vehicleId"],
    status: json?["status"],
    isAvailable: json?["isAvailable"] ?? false,
    heading: json?["heading"],
    isOnline: json?["isOnline"] ?? false,
    speed: json?["speed"],
    accuracy: json?["accuracy"],
    paymentMethods: json?["paymentMethods"] ?? [],
    withdrawals: json?["withdrawals"] ?? [],
    v: json?["__v"],
    currentRideId: json?["currentRideId"],
    stripeDriverId: json?["stripeDriverId"],
    city: json?["city"],
    dateOfBirth: json?["date_of_birth"],
    emergencyContact: json?["emergency_contact"] != null
        ? EmergencyContact.fromJson(json!["emergency_contact"])
        : null,
    state: json?["state"],
    streetAddress: json?["street_address"],
    zipcode: json?["zipcode"],
  );

  Map<String, dynamic> toJson() => {
    "currentLocation": currentLocation?.toJson(),
    "earnings": earnings?.toJson(),
    "ratings": ratings?.toJson(),
    "_id": id,
    "userId": userId,
    "vehicleId": vehicleId,
    "status": status,
    "isAvailable": isAvailable,
    "heading": heading,
    "isOnline": isOnline,
    "speed": speed,
    "accuracy": accuracy,
    "paymentMethods": paymentMethods,
    "withdrawals": withdrawals,
    "__v": v,
    "currentRideId": currentRideId,
    "stripeDriverId": stripeDriverId,
    "city": city,
    "date_of_birth": dateOfBirth,
    "emergency_contact": emergencyContact?.toJson(),
    "state": state,
    "street_address": streetAddress,
    "zipcode": zipcode,
  };
}

class CurrentLocation {
  final String? type;
  final List<double>? coordinates;

  CurrentLocation({this.type, this.coordinates});

  factory CurrentLocation.fromJson(Map<String, dynamic>? json) => CurrentLocation(
    type: json?["type"],
    coordinates: json?["coordinates"] != null
        ? List<double>.from(json!["coordinates"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "coordinates": coordinates,
  };
}

class Earnings {
  final double total;
  final double available;
  final double withdrawn;

  Earnings({this.total = 0, this.available = 0, this.withdrawn = 0});

  factory Earnings.fromJson(Map<String, dynamic>? json) => Earnings(
    total: json?["total"]?.toDouble() ?? 0,
    available: json?["available"]?.toDouble() ?? 0,
    withdrawn: json?["withdrawn"]?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "available": available,
    "withdrawn": withdrawn,
  };
}

class Ratings {
  final double average;
  final int count1;
  final int count2;
  final int count3;
  final int count4;
  final int count5;
  final int totalRatings;

  Ratings({
    this.average = 0,
    this.count1 = 0,
    this.count2 = 0,
    this.count3 = 0,
    this.count4 = 0,
    this.count5 = 0,
    this.totalRatings = 0,
  });

  factory Ratings.fromJson(Map<String, dynamic>? json) => Ratings(
    average: json?["average"]?.toDouble() ?? 0,
    count1: json?["count1"] ?? 0,
    count2: json?["count2"] ?? 0,
    count3: json?["count3"] ?? 0,
    count4: json?["count4"] ?? 0,
    count5: json?["count5"] ?? 0,
    totalRatings: json?["totalRatings"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "average": average,
    "count1": count1,
    "count2": count2,
    "count3": count3,
    "count4": count4,
    "count5": count5,
    "totalRatings": totalRatings,
  };
}
