

class UpdateProfileResponseModel {
  bool? success;
  String? message;
  DriverProfileData? data;

  UpdateProfileResponseModel({this.success, this.message, this.data});

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponseModel(
      success: json['success'],
      message: json['message'],
      data:
          json['data'] != null ? DriverProfileData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.toJson(),
      };
}


class DriverProfileData {
  CurrentLocation? currentLocation;
  Wallet? wallet;
  NotificationSettings? notificationSettings;
  EmergencyContact? emergencyContact;

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

  List<dynamic>? savedPlaces;
  List<dynamic>? suspensions;
  List<LoginHistory>? loginHistory;

  String? lastSeen;
  String? lastActive;
  String? createdAt;
  int? version;

  // Address
  String? city;
  String? state;
  String? streetAddress;
  String? zipcode;
  String? dateOfBirth;

  DriverProfileData({
    this.currentLocation,
    this.wallet,
    this.notificationSettings,
    this.emergencyContact,
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
    this.savedPlaces,
    this.suspensions,
    this.loginHistory,
    this.lastSeen,
    this.lastActive,
    this.createdAt,
    this.version,
    this.city,
    this.state,
    this.streetAddress,
    this.zipcode,
    this.dateOfBirth,
  });

  factory DriverProfileData.fromJson(Map<String, dynamic> json) {
    return DriverProfileData(
      currentLocation: json['currentLocation'] != null
          ? CurrentLocation.fromJson(json['currentLocation'])
          : null,
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      notificationSettings: json['notificationSettings'] != null
          ? NotificationSettings.fromJson(json['notificationSettings'])
          : null,
      emergencyContact: json['emergency_contact'] != null
          ? EmergencyContact.fromJson(json['emergency_contact'])
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
      savedPlaces: json['savedPlaces'],
      suspensions: json['suspensions'],
      loginHistory: (json['loginHistory'] as List?)
          ?.map((e) => LoginHistory.fromJson(e))
          .toList(),
      lastSeen: json['lastSeen'],
      lastActive: json['lastActive'],
      createdAt: json['createdAt'],
      version: json['__v'],
      city: json['city'],
      state: json['state'],
      streetAddress: json['street_address'],
      zipcode: json['zipcode'],
      dateOfBirth: json['date_of_birth'],
    );
  }

  Map<String, dynamic> toJson() => {
        'currentLocation': currentLocation?.toJson(),
        'wallet': wallet?.toJson(),
        'notificationSettings': notificationSettings?.toJson(),
        'emergency_contact': emergencyContact?.toJson(),
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
        'savedPlaces': savedPlaces,
        'suspensions': suspensions,
        'loginHistory': loginHistory?.map((e) => e.toJson()).toList(),
        'lastSeen': lastSeen,
        'lastActive': lastActive,
        'createdAt': createdAt,
        '__v': version,
        'city': city,
        'state': state,
        'street_address': streetAddress,
        'zipcode': zipcode,
        'date_of_birth': dateOfBirth,
      };
}


class EmergencyContact {
  String? name;
  String? phoneNumber;

  EmergencyContact({this.name, this.phoneNumber});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'phoneNumber': phoneNumber,
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

class Wallet {
  int? balance;
  List<dynamic>? transactions;

  Wallet({this.balance, this.transactions});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: json['balance'],
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
