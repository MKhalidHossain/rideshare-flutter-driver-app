// -------------------------------
// GetAllServicesResponseModel
// -------------------------------

class GetAllServicesResponseModel {
  final bool? success;
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final List<ServiceData>? data;

  GetAllServicesResponseModel({
    this.success,
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.data,
  });

  factory GetAllServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return GetAllServicesResponseModel(
      success: json['success'] ?? false,
      currentPage: json['currentPage'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      totalItems: json['totalItems'] ?? 0,

      // 🔥 FIXED: null-safe list parsing
      data: json['data'] is List
          ? List<ServiceData>.from(
              json['data'].map((x) => ServiceData.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "currentPage": currentPage,
      "totalPages": totalPages,
      "totalItems": totalItems,

      // 🔥 FIXED: Prevents app crash if data == null
      "data": data?.map((e) => e.toJson()).toList() ?? [],
    };
  }
}


// -------------------------------
// ServiceData MODEL
// -------------------------------

class ServiceData {
  final String id;
  final String name;
  final String description;

  final int? baseFare;
  final String? category;
  final String? serviceImage;
  final double? perKmRate;
  final double? perMinuteRate;
  final int? minimumFare;
  final int? cancellationFee;
  final int? capacity;
  final bool isActive;

  final List<String> features;
  final int? estimatedArrivalTime;
  final bool? assignedDrivers;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  final Vehicle? vehicle;

  ServiceData({
    required this.id,
    required this.name,
    required this.description,
    this.baseFare,
    this.category,
    this.serviceImage,
    this.perKmRate,
    this.perMinuteRate,
    this.minimumFare,
    this.cancellationFee,
    this.capacity,
    required this.isActive,
    required this.features,
    this.estimatedArrivalTime,
    this.assignedDrivers,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.vehicle,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['_id'] ?? '', // safe
      name: json['name'] ?? '',
      description: json['description'] ?? '',

      baseFare: json['baseFare'],
      category: json['category'],
      serviceImage: json['serviceImage'],

      // 🔥 FIXED: supports both int & double
      perKmRate: json['perKmRate'] != null
          ? (json['perKmRate'] as num).toDouble()
          : null,

      perMinuteRate: json['perMinuteRate'] != null
          ? (json['perMinuteRate'] as num).toDouble()
          : null,

      minimumFare: json['minimumFare'],
      cancellationFee: json['cancellationFee'],
      capacity: json['capacity'],
      isActive: json['isActive'] ?? false,

      // 🔥 FIXED: prevent null crash
      features: json['features'] != null
          ? List<String>.from(json['features'])
          : [],

      estimatedArrivalTime: json['estimatedArrivalTime'],
      assignedDrivers: json['assignedDrivers'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      v: json['__v'],

      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "description": description,
      "baseFare": baseFare,
      "category": category,
      "serviceImage": serviceImage,
      "perKmRate": perKmRate,
      "perMinuteRate": perMinuteRate,
      "minimumFare": minimumFare,
      "cancellationFee": cancellationFee,
      "capacity": capacity,
      "isActive": isActive,
      "features": features,
      "estimatedArrivalTime": estimatedArrivalTime,
      "assignedDrivers": assignedDrivers,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "__v": v,
      "vehicle": vehicle?.toJson(),
    };
  }
}


// -------------------------------
// VEHICLE MODEL
// -------------------------------

class Vehicle {
  final String taxiName;
  final String model;
  final String plateNumber;
  final String color;
  final int year;
  final String vin;

  Vehicle({
    required this.taxiName,
    required this.model,
    required this.plateNumber,
    required this.color,
    required this.year,
    required this.vin,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      taxiName: json['taxiName'] ?? '',
      model: json['model'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      color: json['color'] ?? '',
      year: json['year'] ?? 0,
      vin: json['vin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "taxiName": taxiName,
      "model": model,
      "plateNumber": plateNumber,
      "color": color,
      "year": year,
      "vin": vin,
    };
  }
}
