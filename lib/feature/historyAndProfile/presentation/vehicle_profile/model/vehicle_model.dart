import 'dart:convert';

VehicleResponse vehicleResponseFromJson(String str) =>
    VehicleResponse.fromJson(json.decode(str));

String vehicleResponseToJson(VehicleResponse data) =>
    json.encode(data.toJson());

class VehicleResponse {
  final bool success;
  final String message;
  final VehicleData data;

  VehicleResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VehicleResponse.fromJson(Map<String, dynamic> json) =>
      VehicleResponse(
        success: json["success"] ?? false,
        message: json["message"] ?? '',
        data: VehicleData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class VehicleData {
  final Vehicle vehicle;
  final Service service;
  final String licenseNumber;
  final String licenseImage;

  VehicleData({
    required this.vehicle,
    required this.service,
    required this.licenseNumber,
    required this.licenseImage,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) => VehicleData(
        vehicle: Vehicle.fromJson(json["vehicle"]),
        service: Service.fromJson(json["service"]),
        licenseNumber: json["licenseNumber"] ?? '',
        licenseImage: json["licenseImage"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "vehicle": vehicle.toJson(),
        "service": service.toJson(),
        "licenseNumber": licenseNumber,
        "licenseImage": licenseImage,
      };
}

class Vehicle {
  final String id;
  final String serviceId;
  final String driverId;
  final String taxiName;
  final String model;
  final String plateNumber;
  final String color;
  final int year;
  final String vin;
  final bool assignedDrivers;
  final String createdAt;
  final String updatedAt;
  final int v;

  Vehicle({
    required this.id,
    required this.serviceId,
    required this.driverId,
    required this.taxiName,
    required this.model,
    required this.plateNumber,
    required this.color,
    required this.year,
    required this.vin,
    required this.assignedDrivers,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        id: json["_id"] ?? '',
        serviceId: json["serviceId"] ?? '',
        driverId: json["driverId"] ?? '',
        taxiName: json["taxiName"] ?? '',
        model: json["model"] ?? '',
        plateNumber: json["plateNumber"] ?? '',
        color: json["color"] ?? '',
        year: json["year"] ?? 0,
        vin: json["vin"] ?? '',
        assignedDrivers: json["assignedDrivers"] ?? false,
        createdAt: json["createdAt"] ?? '',
        updatedAt: json["updatedAt"] ?? '',
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "serviceId": serviceId,
        "driverId": driverId,
        "taxiName": taxiName,
        "model": model,
        "plateNumber": plateNumber,
        "color": color,
        "year": year,
        "vin": vin,
        "assignedDrivers": assignedDrivers,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

class Service {
  final String id;
  final String name;
  final String description;
  final int baseFare;
  final String serviceImage;
  final int perKmRate;
  final int perMinuteRate;
  final int minimumFare;
  final int cancellationFee;
  final int capacity;
  final bool isActive;
  final List<String> features;
  final int estimatedArrivalTime;
  final String createdAt;
  final String updatedAt;
  final int v;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.baseFare,
    required this.serviceImage,
    required this.perKmRate,
    required this.perMinuteRate,
    required this.minimumFare,
    required this.cancellationFee,
    required this.capacity,
    required this.isActive,
    required this.features,
    required this.estimatedArrivalTime,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
        id: json["_id"] ?? '',
        name: json["name"] ?? '',
        description: json["description"] ?? '',
        baseFare: json["baseFare"] ?? 0,
        serviceImage: json["serviceImage"] ?? '',
        perKmRate: json["perKmRate"] ?? 0,
        perMinuteRate: json["perMinuteRate"] ?? 0,
        minimumFare: json["minimumFare"] ?? 0,
        cancellationFee: json["cancellationFee"] ?? 0,
        capacity: json["capacity"] ?? 0,
        isActive: json["isActive"] ?? false,
        features: json["features"] != null
            ? List<String>.from(json["features"])
            : [],
        estimatedArrivalTime: json["estimatedArrivalTime"] ?? 0,
        createdAt: json["createdAt"] ?? '',
        updatedAt: json["updatedAt"] ?? '',
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "baseFare": baseFare,
        "serviceImage": serviceImage,
        "perKmRate": perKmRate,
        "perMinuteRate": perMinuteRate,
        "minimumFare": minimumFare,
        "cancellationFee": cancellationFee,
        "capacity": capacity,
        "isActive": isActive,
        "features": features,
        "estimatedArrivalTime": estimatedArrivalTime,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}
