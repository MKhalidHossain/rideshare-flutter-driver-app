class GetEarningsResponseModel {
  bool? success;
  List<Data>? data;

  GetEarningsResponseModel({this.success, this.data});

  GetEarningsResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  num? totalEstimatedFare;
  int? totalRides;

  Data({this.id, this.totalEstimatedFare, this.totalRides});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['_id']?.toString();
    totalEstimatedFare = json['totalEstimatedFare'];
    totalRides = json['totalRides'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['totalEstimatedFare'] = this.totalEstimatedFare;
    data['totalRides'] = this.totalRides;
    return data;
  }
}
