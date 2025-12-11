class GetTripHistoryResponseModel {
  bool? success;
  Data? data;

  GetTripHistoryResponseModel({this.success, this.data});

  GetTripHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['success'] = success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  List<Rides>? rides;
  Pagination? pagination;

  Data({this.rides, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['rides'] != null) {
      rides = [];
      json['rides'].forEach((v) {
        rides!.add(Rides.fromJson(v));
      });
    }
    pagination =
        json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (rides != null) {
      data['rides'] = rides!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class Rides {
  PickupLocation? pickupLocation;
  PickupLocation? dropoffLocation;
  Rating? rating;
  Commission? commission;
  String? sId;
  CustomerId? customerId;
  String? driverId;
  int? totalFare;
  int? actualDistance;
  int? actualDuration;
  int? finalFare;
  String? status;
  String? paymentMethod;
  String? paymentStatus;
  List<dynamic>? route; // FIXED
  List<Timeline>? timeline;
  String? createdAt;
  int? iV;

  Rides({
    this.pickupLocation,
    this.dropoffLocation,
    this.rating,
    this.commission,
    this.sId,
    this.customerId,
    this.driverId,
    this.totalFare,
    this.actualDistance,
    this.actualDuration,
    this.finalFare,
    this.status,
    this.paymentMethod,
    this.paymentStatus,
    this.route,
    this.timeline,
    this.createdAt,
    this.iV,
  });

  Rides.fromJson(Map<String, dynamic> json) {
    pickupLocation = json['pickupLocation'] != null
        ? PickupLocation.fromJson(json['pickupLocation'])
        : null;

    dropoffLocation = json['dropoffLocation'] != null
        ? PickupLocation.fromJson(json['dropoffLocation'])
        : null;

    rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;

    commission =
        json['commission'] != null ? Commission.fromJson(json['commission']) : null;

    sId = json['_id'];
    customerId =
        json['customerId'] != null ? CustomerId.fromJson(json['customerId']) : null;

    driverId = json['driverId'];
    totalFare = json['totalFare'];
    actualDistance = json['actualDistance'];
    actualDuration = json['actualDuration'];
    finalFare = json['finalFare'];
    status = json['status'];
    paymentMethod = json['paymentMethod'];
    paymentStatus = json['paymentStatus'];

    /// FIXED (route list)
    route = json['route'] != null ? List<dynamic>.from(json['route']) : null;

    if (json['timeline'] != null) {
      timeline = [];
      json['timeline'].forEach((v) {
        timeline!.add(Timeline.fromJson(v));
      });
    }

    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (pickupLocation != null) {
      data['pickupLocation'] = pickupLocation!.toJson();
    }
    if (dropoffLocation != null) {
      data['dropoffLocation'] = dropoffLocation!.toJson();
    }
    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    if (commission != null) {
      data['commission'] = commission!.toJson();
    }

    data['_id'] = sId;
    if (customerId != null) {
      data['customerId'] = customerId!.toJson();
    }

    data['driverId'] = driverId;
    data['totalFare'] = totalFare;
    data['actualDistance'] = actualDistance;
    data['actualDuration'] = actualDuration;
    data['finalFare'] = finalFare;
    data['status'] = status;
    data['paymentMethod'] = paymentMethod;
    data['paymentStatus'] = paymentStatus;

    if (route != null) {
      data['route'] = route;
    }

    if (timeline != null) {
      data['timeline'] = timeline!.map((v) => v.toJson()).toList();
    }

    data['createdAt'] = createdAt;
    data['__v'] = iV;

    return data;
  }
}

class PickupLocation {
  List<double>? coordinates;
  String? address;
  String? type;

  PickupLocation({this.coordinates, this.address, this.type});

  PickupLocation.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'] != null
        ? List<double>.from(json['coordinates'].map((x) => x.toDouble()))
        : null;
    address = json['address'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['coordinates'] = coordinates;
    data['address'] = address;
    data['type'] = type;
    return data;
  }
}

class Rating {
  CustomerToDriver? customerToDriver;
  CustomerToDriver? driverToCustomer;

  Rating({this.customerToDriver, this.driverToCustomer});

  Rating.fromJson(Map<String, dynamic> json) {
    customerToDriver = json['customerToDriver'] != null
        ? CustomerToDriver.fromJson(json['customerToDriver'])
        : null;

    driverToCustomer = json['driverToCustomer'] != null
        ? CustomerToDriver.fromJson(json['driverToCustomer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (customerToDriver != null) {
      data['customerToDriver'] = customerToDriver!.toJson();
    }
    if (driverToCustomer != null) {
      data['driverToCustomer'] = driverToCustomer!.toJson();
    }
    return data;
  }
}

class CustomerToDriver {
  String? ratedAt;

  CustomerToDriver({this.ratedAt});

  CustomerToDriver.fromJson(Map<String, dynamic> json) {
    ratedAt = json['ratedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ratedAt'] = ratedAt;
    return data;
  }
}

class Commission {
  double? rate;
  int? amount;

  Commission({this.rate, this.amount});

  Commission.fromJson(Map<String, dynamic> json) {
    rate = json['rate']?.toDouble();
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['rate'] = rate;
    data['amount'] = amount;
    return data;
  }
}

class CustomerId {
  String? sId;
  String? fullName;
  String? profileImage;

  CustomerId({this.sId, this.fullName, this.profileImage});

  CustomerId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    fullName = json['fullName'];
    profileImage = json['profileImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['fullName'] = fullName;
    data['profileImage'] = profileImage;
    return data;
  }
}

class Timeline {
  String? status;
  String? timestamp;
  String? sId;

  Timeline({this.status, this.timestamp, this.sId});

  Timeline.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    timestamp = json['timestamp'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['timestamp'] = timestamp;
    data['_id'] = sId;
    return data;
  }
}

class Pagination {
  int? current;
  int? pages;
  int? total;

  Pagination({this.current, this.pages, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    current = json['current'];
    pages = json['pages'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['current'] = current;
    data['pages'] = pages;
    data['total'] = total;
    return data;
  }
}
