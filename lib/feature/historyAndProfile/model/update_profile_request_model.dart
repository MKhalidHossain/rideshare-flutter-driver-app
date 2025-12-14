import 'driver_profile_model.dart';

class UpdateProfileRequestModel {
  String? fullName;
  String? phoneNumber;
  String? email;
  String? streetAddress;
  String? city;
  String? state;
  String? zipcode;
  String? dateOfBirth;
  String? profileImage;
  String? licenseNumber;
  String? licenseImage;
  String? nidNumber;
  String? nidImage;
  String? selfieImage;
  List<String>? serviceTypes;
  EmergencyContact? emergencyContact;

  UpdateProfileRequestModel({
    this.fullName,
    this.phoneNumber,
    this.email,
    this.streetAddress,
    this.city,
    this.state,
    this.zipcode,
    this.dateOfBirth,
    this.profileImage,
    this.licenseNumber,
    this.licenseImage,
    this.nidNumber,
    this.nidImage,
    this.selfieImage,
    this.serviceTypes,
    this.emergencyContact,
  });

  factory UpdateProfileRequestModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileRequestModel(
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      email: json['email'],
      streetAddress: json['street_address'],
      city: json['city'],
      state: json['state'],
      zipcode: json['zipcode'],
      dateOfBirth: json['date_of_birth'],
      profileImage: json['profile_image'],
      licenseNumber: json['license_number'],
      licenseImage: json['license_image'],
      nidNumber: json['nid_number'],
      nidImage: json['nid_image'],
      selfieImage: json['selfie_image'],
      serviceTypes:
          (json['service_types'] as List?)?.map((e) => e.toString()).toList(),
      emergencyContact: json['emergency_contact'] != null
          ? EmergencyContact.fromJson(json['emergency_contact'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // camelCase keys
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'email': email,
      'streetAddress': streetAddress,
      'city': city,
      'state': state,
      'zipcode': zipcode,
      'dateOfBirth': dateOfBirth,
      // snake_case fallback keys (backend compatibility)
      'full_name': fullName,
      'phone_number': phoneNumber,
      'street_address': streetAddress,
      'date_of_birth': dateOfBirth,
      // media and misc
      'profile_image': profileImage,
      'license_number': licenseNumber,
      'license_image': licenseImage,
      'nid_number': nidNumber,
      'nid_image': nidImage,
      'selfie_image': selfieImage,
      'service_types': serviceTypes,
      // emergency contact object and flat fields
      'emergency_contact': emergencyContact?.toJson(),
      'emergency_contact_name': emergencyContact?.name,
      'emergency_contact_phone': emergencyContact?.phoneNumber,
    };
  }
}
