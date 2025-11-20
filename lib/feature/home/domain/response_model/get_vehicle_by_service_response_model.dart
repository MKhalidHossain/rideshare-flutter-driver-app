class GetVehicleByServiceResponseModel {
  bool? success;
  int? total;
  int? page;
  int? totalPages;
  List<VehicleData>? data;

  GetVehicleByServiceResponseModel({
    this.success,
    this.total,
    this.page,
    this.totalPages,
    this.data,
  });

  GetVehicleByServiceResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    total = json['total'];
    page = json['page'];
    totalPages = json['totalPages'];
    if (json['data'] != null) {
      data = <VehicleData>[];
      json['data'].forEach((v) {
        data!.add(VehicleData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['total'] = total;
    map['page'] = page;
    map['totalPages'] = totalPages;
    if (data != null) {
      map['data'] = data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class VehicleData {
  String? id;
  String? serviceId;
  String? driverId;
  String? taxiName;
  String? model;
  String? plateNumber;
  String? color;
  int? year;
  String? vin;
  bool? assignedDrivers;
  String? createdAt;
  String? updatedAt;
  int? v;

  VehicleData({
    this.id,
    this.serviceId,
    this.driverId,
    this.taxiName,
    this.model,
    this.plateNumber,
    this.color,
    this.year,
    this.vin,
    this.assignedDrivers,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  VehicleData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    serviceId = json['serviceId'];
    driverId = json['driverId'];
    taxiName = json['taxiName'];
    model = json['model'];
    plateNumber = json['plateNumber'];
    color = json['color'];
    year = json['year'];
    vin = json['vin'];
    assignedDrivers = json['assignedDrivers'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    v = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['_id'] = id;
    map['serviceId'] = serviceId;
    map['driverId'] = driverId;
    map['taxiName'] = taxiName;
    map['model'] = model;
    map['plateNumber'] = plateNumber;
    map['color'] = color;
    map['year'] = year;
    map['vin'] = vin;
    map['assignedDrivers'] = assignedDrivers;
    map['createdAt'] = createdAt;
    map['updatedAt'] = updatedAt;
    map['__v'] = v;
    return map;
  }
}
