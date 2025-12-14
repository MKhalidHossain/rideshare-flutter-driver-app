class ReviewRatingModel {
  List<Review> reviews;
  Pagination pagination;
  double averageRating;
  StarBreakdown starBreakdown;
  StarPercentages starPercentages;

  ReviewRatingModel({
    required this.reviews,
    required this.pagination,
    required this.averageRating,
    required this.starBreakdown,
    required this.starPercentages,
  });

  factory ReviewRatingModel.fromJson(Map<String, dynamic> json) {
    final ratingStats = json['ratingStats'] ?? {};
    return ReviewRatingModel(
      reviews: (json['reviews'] as List<dynamic>? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
      averageRating: double.tryParse(
        ratingStats['averageRating']?.toString() ?? '0.0',
      ) ??
          0.0,
      starBreakdown: StarBreakdown.fromJson(ratingStats['starBreakdown'] ?? {}),
      starPercentages: StarPercentages.fromJson(ratingStats['starPercentages'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviews': reviews.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
      'averageRating': averageRating,
      'starBreakdown': starBreakdown.toJson(),
      'starPercentages': starPercentages.toJson(),
    };
  }
}

class Review {
  Customer customer;
  int rating;
  String? comment;
  DateTime? ratedAt;

  Review({
    required this.customer,
    required this.rating,
    this.comment,
    this.ratedAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      customer: Customer.fromJson(json['customer']),
      rating: json['rating'] ?? 0,
      comment: json['comment'],
      ratedAt: json['ratedAt'] != null ? DateTime.parse(json['ratedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': customer.toJson(),
      'rating': rating,
      'comment': comment,
      'ratedAt': ratedAt?.toIso8601String(),
    };
  }
}

class Customer {
  String id;
  String name;
  String? profileImage;

  Customer({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
    };
  }
}

class Pagination {
  int currentPage;
  int totalPages;
  int totalReviews;
  int limit;
  bool hasNextPage;
  bool hasPrevPage;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalReviews,
    required this.limit,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalReviews: json['totalReviews'] ?? 0,
      limit: json['limit'] ?? 10,
      hasNextPage: json['hasNextPage'] ?? false,
      hasPrevPage: json['hasPrevPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalReviews': totalReviews,
      'limit': limit,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}

class StarBreakdown {
  int oneStar;
  int twoStar;
  int threeStar;
  int fourStar;
  int fiveStar;

  StarBreakdown({
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
    required this.fourStar,
    required this.fiveStar,
  });

  factory StarBreakdown.fromJson(Map<String, dynamic> json) {
    return StarBreakdown(
      oneStar: json['oneStar'] ?? 0,
      twoStar: json['twoStar'] ?? 0,
      threeStar: json['threeStar'] ?? 0,
      fourStar: json['fourStar'] ?? 0,
      fiveStar: json['fiveStar'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oneStar': oneStar,
      'twoStar': twoStar,
      'threeStar': threeStar,
      'fourStar': fourStar,
      'fiveStar': fiveStar,
    };
  }
}

class StarPercentages {
  double oneStar;
  double twoStar;
  double threeStar;
  double fourStar;
  double fiveStar;

  StarPercentages({
    required this.oneStar,
    required this.twoStar,
    required this.threeStar,
    required this.fourStar,
    required this.fiveStar,
  });

  factory StarPercentages.fromJson(Map<String, dynamic> json) {
    return StarPercentages(
      oneStar: double.tryParse(json['oneStar']?.toString() ?? '0') ?? 0.0,
      twoStar: double.tryParse(json['twoStar']?.toString() ?? '0') ?? 0.0,
      threeStar: double.tryParse(json['threeStar']?.toString() ?? '0') ?? 0.0,
      fourStar: double.tryParse(json['fourStar']?.toString() ?? '0') ?? 0.0,
      fiveStar: double.tryParse(json['fiveStar']?.toString() ?? '0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oneStar': oneStar,
      'twoStar': twoStar,
      'threeStar': threeStar,
      'fourStar': fourStar,
      'fiveStar': fiveStar,
    };
  }
}
