
class DriverProfileResponse {
  bool? success;
  ProfileData? profileData;
  DriverData? driverData;

  DriverProfileResponse({
    this.success,
    this.profileData,
    this.driverData,
  });

  factory DriverProfileResponse.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> root =
        json['data'] is Map<String, dynamic> ? Map<String, dynamic>.from(json['data']) : json;
    return DriverProfileResponse(
      success: json['success'],
      profileData: root['profileData'] != null
          ? ProfileData.fromJson(root['profileData'])
          : null,
      driverData: root['driverData'] != null
          ? DriverData.fromJson(root['driverData'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'profileData': profileData?.toJson(),
        'driverData': driverData?.toJson(),
      };
}


class ProfileData {
  Wallet? wallet;
  NotificationSettings? notificationSettings;
  String? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? role;
  String? profileImage;
  bool? isEmailVerified;
  bool? isPhoneVerified;
  String? licenseNumber;
  String? licenseImage;
  String? nidNumber;
  String? nidImage;
  String? selfieImage;
  List<String>? serviceTypes;
  String? refreshToken;
  bool? isActive;
  EmergencyContact? emergencyContact;
  List<dynamic>? savedPlaces;
  List<dynamic>? suspensions;
  List<LoginHistory>? loginHistory;
  String? lastSeen;
  String? lastActive;
  String? createdAt;
  String? city;
  String? dateOfBirth;
  String? state;
  String? streetAddress;
  String? zipcode;
  int? version;

  ProfileData({
    this.wallet,
    this.notificationSettings,
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.role,
    this.profileImage,
    this.isEmailVerified,
    this.isPhoneVerified,
    this.licenseNumber,
    this.licenseImage,
    this.nidNumber,
    this.nidImage,
    this.selfieImage,
    this.serviceTypes,
    this.refreshToken,
    this.isActive,
    this.emergencyContact,
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
    this.version,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      notificationSettings: json['notificationSettings'] != null
          ? NotificationSettings.fromJson(json['notificationSettings'])
          : null,
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      profileImage: json['profileImage'],
      isEmailVerified: json['isEmailVerified'],
      isPhoneVerified: json['isPhoneVerified'],
      licenseNumber: json['licenseNumber'],
      licenseImage: json['licenseImage'],
      nidNumber: json['nidNumber'],
      nidImage: json['nidImage'],
      selfieImage: json['selfieImage'],
      serviceTypes:
          (json['serviceTypes'] as List?)?.map((e) => e.toString()).toList(),
      refreshToken: json['refreshToken'],
      isActive: json['isActive'],
      emergencyContact: json['emergency_contact'] != null
          ? EmergencyContact.fromJson(json['emergency_contact'])
          : null,
      savedPlaces: json['savedPlaces'],
      suspensions: json['suspensions'],
      loginHistory: (json['loginHistory'] as List?)
          ?.map((e) => LoginHistory.fromJson(e))
          .toList(),
      lastSeen: json['lastSeen'],
      lastActive: json['lastActive'],
      createdAt: json['createdAt'],
      city: json['city'],
      dateOfBirth: json['date_of_birth'],
      state: json['state'],
      streetAddress: json['street_address'],
      zipcode: json['zipcode'],
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() => {
        'wallet': wallet?.toJson(),
        'notificationSettings': notificationSettings?.toJson(),
        '_id': id,
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'role': role,
        'profileImage': profileImage,
        'isEmailVerified': isEmailVerified,
        'isPhoneVerified': isPhoneVerified,
        'licenseNumber': licenseNumber,
        'licenseImage': licenseImage,
        'nidNumber': nidNumber,
        'nidImage': nidImage,
        'selfieImage': selfieImage,
        'serviceTypes': serviceTypes,
        'refreshToken': refreshToken,
        'isActive': isActive,
        'emergency_contact': emergencyContact?.toJson(),
        'savedPlaces': savedPlaces,
        'suspensions': suspensions,
        'loginHistory': loginHistory?.map((e) => e.toJson()).toList(),
        'lastSeen': lastSeen,
        'lastActive': lastActive,
        'createdAt': createdAt,
        'city': city,
        'date_of_birth': dateOfBirth,
        'state': state,
        'street_address': streetAddress,
        'zipcode': zipcode,
        '__v': version,
      };
}
class Wallet {
  double? balance;
  List<dynamic>? transactions;

  Wallet({this.balance, this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: (json['balance'] as num?)?.toDouble(),
      transactions: json['transactions'],
    );
  }

  Map<String, dynamic> toJson() => {
        'balance': balance,
        'transactions': transactions,
      };
}

class NotificationSettings {
  bool? pushNotifications;
  bool? emailNotifications;
  bool? smsNotifications;

  NotificationSettings({
    this.pushNotifications,
    this.emailNotifications,
    this.smsNotifications,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      pushNotifications: json['pushNotifications'],
      emailNotifications: json['emailNotifications'],
      smsNotifications: json['smsNotifications'],
    );
  }

  Map<String, dynamic> toJson() => {
        'pushNotifications': pushNotifications,
        'emailNotifications': emailNotifications,
        'smsNotifications': smsNotifications,
      };
}

class EmergencyContact {
  String? name;
  String? phoneNumber;

  EmergencyContact({this.name, this.phoneNumber});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      phoneNumber: json['phoneNumber'] ?? json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
      };
}


class LoginHistory {
  String? device;
  String? ipAddress;
  String? id;
  String? loginTime;

  LoginHistory({
    this.device,
    this.ipAddress,
    this.id,
    this.loginTime,
  });

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
      device: json['device'],
      ipAddress: json['ipAddress'],
      id: json['_id'],
      loginTime: json['loginTime'],
    );
  }

  Map<String, dynamic> toJson() => {
        'device': device,
        'ipAddress': ipAddress,
        '_id': id,
        'loginTime': loginTime,
      };
}


class DriverData {
  CurrentLocation? currentLocation;
  Earnings? earnings;
  Ratings? ratings;
  String? id;
  String? userId;
  String? vehicleId;
  String? status;
  bool? isAvailable;
  int? heading;
  bool? isOnline;
  double? speed;
  double? accuracy;
  List<dynamic>? paymentMethods;
  List<dynamic>? withdrawals;
  int? version;
  String? stripeDriverId;
  String? currentRideId;

  DriverData({
    this.currentLocation,
    this.earnings,
    this.ratings,
    this.id,
    this.userId,
    this.vehicleId,
    this.status,
    this.isAvailable,
    this.heading,
    this.isOnline,
    this.speed,
    this.accuracy,
    this.paymentMethods,
    this.withdrawals,
    this.version,
    this.stripeDriverId,
    this.currentRideId,
  });

  factory DriverData.fromJson(Map<String, dynamic> json) {
    return DriverData(
      currentLocation: json['currentLocation'] != null
          ? CurrentLocation.fromJson(json['currentLocation'])
          : null,
      earnings:
          json['earnings'] != null ? Earnings.fromJson(json['earnings']) : null,
      ratings:
          json['ratings'] != null ? Ratings.fromJson(json['ratings']) : null,
      id: json['_id'],
      userId: json['userId'],
      vehicleId: json['vehicleId'],
      status: json['status'],
      isAvailable: json['isAvailable'],
      heading: json['heading'],
      isOnline: json['isOnline'],
      speed: (json['speed'] as num?)?.toDouble(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      paymentMethods: json['paymentMethods'],
      withdrawals: json['withdrawals'],
      version: json['__v'],
      stripeDriverId: json['stripeDriverId'],
      currentRideId: json['currentRideId'],
    );
  }

  Map<String, dynamic> toJson() => {
        'currentLocation': currentLocation?.toJson(),
        'earnings': earnings?.toJson(),
        'ratings': ratings?.toJson(),
        '_id': id,
        'userId': userId,
        'vehicleId': vehicleId,
        'status': status,
        'isAvailable': isAvailable,
        'heading': heading,
        'isOnline': isOnline,
        'speed': speed,
        'accuracy': accuracy,
        'paymentMethods': paymentMethods,
        'withdrawals': withdrawals,
        '__v': version,
        'stripeDriverId': stripeDriverId,
        'currentRideId': currentRideId,
      };
}


class CurrentLocation {
  String? type;
  List<double>? coordinates;

  CurrentLocation({this.type, this.coordinates});

  factory CurrentLocation.fromJson(Map<String, dynamic> json) {
    return CurrentLocation(
      type: json['type'],
      coordinates: (json['coordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}


class Earnings {
  double? total;
  double? available;
  double? withdrawn;

  Earnings({this.total, this.available, this.withdrawn});

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      total: (json['total'] as num?)?.toDouble(),
      available: (json['available'] as num?)?.toDouble(),
      withdrawn: (json['withdrawn'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total': total,
        'available': available,
        'withdrawn': withdrawn,
      };
}

class Ratings {
  double? average;
  int? totalRatings;
  int? count1;
  int? count2;
  int? count3;
  int? count4;
  int? count5;

  Ratings({
    this.average,
    this.totalRatings,
    this.count1,
    this.count2,
    this.count3,
    this.count4,
    this.count5,
  });

  factory Ratings.fromJson(Map<String, dynamic> json) {
    return Ratings(
      average: (json['average'] as num?)?.toDouble(),
      totalRatings: json['totalRatings'],
      count1: json['count1'],
      count2: json['count2'],
      count3: json['count3'],
      count4: json['count4'],
      count5: json['count5'],
    );
  }

  Map<String, dynamic> toJson() => {
        'average': average,
        'totalRatings': totalRatings,
        'count1': count1,
        'count2': count2,
        'count3': count3,
        'count4': count4,
        'count5': count5,
      };
}
