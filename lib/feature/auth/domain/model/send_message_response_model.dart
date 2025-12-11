class SendMessageResponseModel {
  final bool? success;
  final String? message;
  final MessageData? data;

  SendMessageResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return SendMessageResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? MessageData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class MessageData {
  final String? rideId;
  final String? sender;
  final String? recipient;
  final String? message;
  final bool? read;
  final String? readAt;
  final String? id;
  final String? timestamp;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  MessageData({
    this.rideId,
    this.sender,
    this.recipient,
    this.message,
    this.read,
    this.readAt,
    this.id,
    this.timestamp,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      rideId: json['rideId'],
      sender: json['sender'],
      recipient: json['recipient'],
      message: json['message'],
      read: json['read'],
      readAt: json['readAt'],
      id: json['_id'],
      timestamp: json['timestamp'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'sender': sender,
      'recipient': recipient,
      'message': message,
      'read': read,
      'readAt': readAt,
      '_id': id,
      'timestamp': timestamp,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}
