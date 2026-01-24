// =====================
// SAFE PARSERS (GLOBAL)
// =====================
double? parseDouble(dynamic value) {
  if (value == null) return null;
  return (value as num).toDouble();
}

int? parseInt(dynamic value) {
  if (value == null) return null;
  return (value as num).toInt();
}

// =====================
// RESPONSE MODEL
// =====================
class GetTripHistoryResponseModel {
  bool? success;
  Data? data;

  GetTripHistoryResponseModel({this.success, this.data});

  GetTripHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'data': data?.toJson(),
      };
}

// =====================
// DATA
// =====================
class Data {
  List<Rides>? rides;
  Pagination? pagination;

  Data({this.rides, this.pagination});

  Data.fromJson(Map<String, dynamic> json) {
    rides = (json['rides'] as List?)
        ?.map((e) => Rides.fromJson(e))
        .toList();

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() => {
        'rides': rides?.map((e) => e.toJson()).toList(),
        'pagination': pagination?.toJson(),
      };
}

// =====================
// RIDES
// =====================
class Rides {
  PickupLocation? pickupLocation;
  PickupLocation? dropoffLocation;
  Rating? rating;
  Commission? commission;
  String? sId;
  CustomerId? customerId;
  String? driverId;

  double? totalFare;
  double? actualDistance;
  double? actualDuration;
  double? finalFare;

  String? status;
  String? paymentMethod;
  String? paymentStatus;

  List<dynamic>? route;
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

    totalFare = parseDouble(json['totalFare']);
    actualDistance = parseDouble(json['actualDistance']);
    actualDuration = parseDouble(json['actualDuration']);
    finalFare = parseDouble(json['finalFare']);

    status = json['status'];
    paymentMethod = json['paymentMethod'];
    paymentStatus = json['paymentStatus'];

    route = json['route'] != null ? List<dynamic>.from(json['route']) : null;

    timeline = (json['timeline'] as List?)
        ?.map((e) => Timeline.fromJson(e))
        .toList();

    createdAt = json['createdAt'];
    iV = parseInt(json['__v']);
  }

  Map<String, dynamic> toJson() => {
        'pickupLocation': pickupLocation?.toJson(),
        'dropoffLocation': dropoffLocation?.toJson(),
        'rating': rating?.toJson(),
        'commission': commission?.toJson(),
        '_id': sId,
        'customerId': customerId?.toJson(),
        'driverId': driverId,
        'totalFare': totalFare,
        'actualDistance': actualDistance,
        'actualDuration': actualDuration,
        'finalFare': finalFare,
        'status': status,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'route': route,
        'timeline': timeline?.map((e) => e.toJson()).toList(),
        'createdAt': createdAt,
        '__v': iV,
      };
}

// =====================
// PICKUP / DROPOFF
// =====================
class PickupLocation {
  List<double>? coordinates;
  String? address;
  String? type;

  PickupLocation({this.coordinates, this.address, this.type});

  PickupLocation.fromJson(Map<String, dynamic> json) {
    coordinates = (json['coordinates'] as List?)
        ?.map((e) => (e as num).toDouble())
        .toList();

    address = json['address'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() => {
        'coordinates': coordinates,
        'address': address,
        'type': type,
      };
}

// =====================
// RATING
// =====================
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

  Map<String, dynamic> toJson() => {
        'customerToDriver': customerToDriver?.toJson(),
        'driverToCustomer': driverToCustomer?.toJson(),
      };
}

class CustomerToDriver {
  String? ratedAt;

  CustomerToDriver({this.ratedAt});

  CustomerToDriver.fromJson(Map<String, dynamic> json) {
    ratedAt = json['ratedAt'];
  }

  Map<String, dynamic> toJson() => {'ratedAt': ratedAt};
}

// =====================
// COMMISSION
// =====================
class Commission {
  double? rate;
  int? amount;

  Commission({this.rate, this.amount});

  Commission.fromJson(Map<String, dynamic> json) {
    rate = parseDouble(json['rate']);
    amount = parseInt(json['amount']);
  }

  Map<String, dynamic> toJson() => {
        'rate': rate,
        'amount': amount,
      };
}

// =====================
// CUSTOMER
// =====================
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

  Map<String, dynamic> toJson() => {
        '_id': sId,
        'fullName': fullName,
        'profileImage': profileImage,
      };
}

// =====================
// TIMELINE
// =====================
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

  Map<String, dynamic> toJson() => {
        'status': status,
        'timestamp': timestamp,
        '_id': sId,
      };
}

// =====================
// PAGINATION
// =====================
class Pagination {
  int? current;
  int? pages;
  int? total;

  Pagination({this.current, this.pages, this.total});

  Pagination.fromJson(Map<String, dynamic> json) {
    current = parseInt(json['current']);
    pages = parseInt(json['pages']);
    total = parseInt(json['total']);
  }

  Map<String, dynamic> toJson() => {
        'current': current,
        'pages': pages,
        'total': total,
      };
}
