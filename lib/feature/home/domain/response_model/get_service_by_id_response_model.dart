class GetServiceByIdResponseModel {
  final bool? success;
  final ServiceData? data;

  GetServiceByIdResponseModel({
    this.success,
    this.data,
  });

  factory GetServiceByIdResponseModel.fromJson(Map<String, dynamic> json) {
    return GetServiceByIdResponseModel(
      success: json['success'],
      data: json['data'] != null ? ServiceData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class ServiceData {
  final String? id;
  final String? name;
  final String? description;
  final num? baseFare;
  final String? serviceImage;
  final num? perKmRate;
  final num? perMinuteRate;
  final num? minimumFare;
  final num? cancellationFee;
  final int? capacity;
  final bool? isActive;
  final List<dynamic>? features;
  final int? estimatedArrivalTime;
  final bool? assignedDrivers;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final Vehicle? vehicle;

  ServiceData({
    this.id,
    this.name,
    this.description,
    this.baseFare,
    this.serviceImage,
    this.perKmRate,
    this.perMinuteRate,
    this.minimumFare,
    this.cancellationFee,
    this.capacity,
    this.isActive,
    this.features,
    this.estimatedArrivalTime,
    this.assignedDrivers,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.vehicle,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    return ServiceData(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      baseFare: json['baseFare'],
      serviceImage: json['serviceImage'],
      perKmRate: json['perKmRate'],
      perMinuteRate: json['perMinuteRate'],
      minimumFare: json['minimumFare'],
      cancellationFee: json['cancellationFee'],
      capacity: json['capacity'],
      isActive: json['isActive'],
      features: json['features'] ?? [],
      estimatedArrivalTime: json['estimatedArrivalTime'],
      assignedDrivers: json['assignedDrivers'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      vehicle: json['vehicle'] != null
          ? Vehicle.fromJson(json['vehicle'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'baseFare': baseFare,
      'serviceImage': serviceImage,
      'perKmRate': perKmRate,
      'perMinuteRate': perMinuteRate,
      'minimumFare': minimumFare,
      'cancellationFee': cancellationFee,
      'capacity': capacity,
      'isActive': isActive,
      'features': features,
      'estimatedArrivalTime': estimatedArrivalTime,
      'assignedDrivers': assignedDrivers,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'vehicle': vehicle?.toJson(),
    };
  }
}

class Vehicle {
  final String? taxiName;
  final String? model;
  final String? plateNumber;
  final String? color;
  final int? year;
  final String? vin;

  Vehicle({
    this.taxiName,
    this.model,
    this.plateNumber,
    this.color,
    this.year,
    this.vin,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      taxiName: json['taxiName'],
      model: json['model'],
      plateNumber: json['plateNumber'],
      color: json['color'],
      year: json['year'],
      vin: json['vin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taxiName': taxiName,
      'model': model,
      'plateNumber': plateNumber,
      'color': color,
      'year': year,
      'vin': vin,
    };
  }
}
