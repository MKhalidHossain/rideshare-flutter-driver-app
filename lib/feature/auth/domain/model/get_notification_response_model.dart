class GetNotificationResponseModel {
  bool? success;
  NotificationData? data;

  GetNotificationResponseModel({
    this.success,
    this.data,
  });

  factory GetNotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return GetNotificationResponseModel(
      success: json['success'],
      data: json['data'] != null
          ? NotificationData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class NotificationData {
  List<NotificationItem>? notifications;
  Pagination? pagination;

  NotificationData({
    this.notifications,
    this.pagination,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      notifications: json['notifications'] != null
          ? (json['notifications'] as List)
              .map((e) => NotificationItem.fromJson(e))
              .toList()
          : [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications?.map((e) => e.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class NotificationItem {
  String? id;
  UserInfo? sender;
  UserInfo? receiver;
  String? title;
  String? message;
  String? type;
  bool? isRead;
  DateTime? createdAt;
  int? version;

  NotificationItem({
    this.id,
    this.sender,
    this.receiver,
    this.title,
    this.message,
    this.type,
    this.isRead,
    this.createdAt,
    this.version,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['_id'],
      sender: json['senderId'] != null
          ? UserInfo.fromJson(json['senderId'])
          : null,
      receiver: json['receiverId'] != null
          ? UserInfo.fromJson(json['receiverId'])
          : null,
      title: json['title'],
      message: json['message'],
      type: json['type'],
      isRead: json['isRead'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'senderId': sender?.toJson(),
      'receiverId': receiver?.toJson(),
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt?.toIso8601String(),
      '__v': version,
    };
  }
}

class UserInfo {
  String? id;
  String? fullName;
  String? profileImage;

  UserInfo({
    this.id,
    this.fullName,
    this.profileImage,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'],
      fullName: json['fullName'],
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'profileImage': profileImage,
    };
  }
}

class Pagination {
  int? current;
  int? pages;
  int? total;

  Pagination({
    this.current,
    this.pages,
    this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      current: json['current'],
      pages: json['pages'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current,
      'pages': pages,
      'total': total,
    };
  }
}
